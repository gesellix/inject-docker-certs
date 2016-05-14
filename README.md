# Inject Docker Certificates

Easily add certificates to the [Docker for Mac beta](https://beta.docker.com/) daemon.

See [Adding (self signed) certificates](https://forums.docker.com/t/adding-self-signed-certificates/9761) for the rough idea.

When trying to use a private Docker Registry in your Docker for Mac beta, you'll run into security issues: you need to configure the daemon to either [accept an insecure registry or to use certificates](https://docs.docker.com/registry/insecure/). Ok, we're going to configure the certificates. This repo gives you a simple way to configure your Docker daemon inside a Docker for Mac beta VM.


## Creating Certificates

Let's start with generating a full set of self signed certificates, along with a CA certificate. They'll be put into the `./certs` subfolder:

    DOMAIN=my-hostname PORT=5000 ./create-certs.sh

You can obviously skip that step if you alread have some certificates. Please ensure that you provide the following files in the `./certs` subfolder to make the following examples work:

- ca.cert
- cert.key
- cert.cert


## The Hack

Then we need to somehow copy those certificates into the Docker VM. That's actually quite easy when thinking about some little details:

- the `/Users/...` folder is already mounted from your host into the VM
- any folder, especially the `/Users` folder, can be mounted from the VM into a container
- system folders like `/etc` can be mounted from the VM into a container

So, the container can access both your host's file system and the VM's file system. We're going to use the container to simply copy from the host (`/certs`) to the VM (`/vm-etc`). We also need to tell the Docker daemon to trust our certificates, which is why we also append our CA certificate to the VM's list of trusted certificates. Everything packaged in a Docker image, for your convenience:

    docker run --rm -it -v `pwd`/certs:/certs -v /etc:/vm-etc -e DOMAIN=my-hostname -e PORT=5000 gesellix/inject-docker-certs

What's left? Running the registry. That's what it's all about, right?

    docker run --rm -it -p 5000:5000 -v `pwd`/certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/my-hostname:5000/cert.cert -e REGISTRY_HTTP_TLS_KEY=/certs/my-hostname:5000/cert.key registry:2


### Bonus

When trying the hack on Docker for Mac beta 1.10 I needed to restart the Docker daemon. With the current release _1.11.1-beta11 (build: 6974)_ that doesn't seem to be necessary anymore. If you think you need to do so, here's another hack to ensure that the daemon will be restarted...

The Docker VM has `cron` running and already provides a structure to make a task run every 15 minutes. Instead of manually (and instantly) restart the daemon we can simply add a shell script to do it for us. The `entrypoint.sh` script is already prepared for that hack, so if need be you can simply [un-comment the last two lines](https://github.com/gesellix/inject-docker-certs/blob/7821ff65743b0154fa3b010fff6416292d8cf862/entrypoint.sh#L10) and mount the changed script into the container like this:

    docker run --rm -it -v `pwd`/certs:/certs -v /etc:/vm-etc -e DOMAIN=my-hostname -e PORT=5000 -v `pwd`/entrypoint.sh:/entrypoint.sh gesellix/inject-docker-certs

The downside of that approach is that you need to wait up to 15 minutes until you can be sure that the daemon has been restarted.


### Future

This hack is only necessary as long as the Docker for Mac (and Windows) is in beta. Since the VM will be clean after a restart, the method above helps to easily copy the certs back into the VM. The Docker maintainers will certainly find a way to make the whole setup much more convenient and less hacky.


## Contact/Contributions

If something crazy happens after applying this hack - please leave a note at the [Docker forum thread](https://forums.docker.com/t/adding-self-signed-certificates/9761).

If everything works beautifully nice and you're happy - relax :-)
 You can also leave feedback at the forum or via Twitter [@gesellix](https://twitter.com/gesellix)!
