# Inject Docker Certificates

Easily add certificates to the Docker for Mac beta daemon.

See [Adding (self signed) certificates](https://forums.docker.com/t/adding-self-signed-certificates/9761) for the rough idea.

When trying to use a private Docker Registry in your Docker for Mac beta, you'll run into security issues: you need to configure the daemon to either accept an insecure registry or to use certificates. Ok, we're going to configure the certificates. This repo gives you a simple way to configure your Docker daemon inside a Docker for Mac beta VM.

Let's start with generating a full set of self signed certificates, along with a CA certificate. They'll be put into the `./certs` subfolder:

    DOMAIN=my-hostname PORT=5000 ./create-certs.sh

Then we need to somehow copy those certificates into the Docker VM. That's actually quite easy when thinking about some little details:

- the `/Users/...` folder is already mounted from your host into the VM
- any folder, especially the `/Users` folder, can be mounted from the VM into a container
- other system folders like `/etc` can be mounted from the VM into a container

So, the container can access both your host's file system and the VM's file system. We're going to use the container to simply copy from the host (`\certs`) to the VM (`\vm-etc`). We also need to tell the Docker daemon to trust our certificates, which is why we also append our CA certificate to the VM's list of trusted certificates. Everything packaged in a Docker image, for your convenience:

    docker run --rm -it -v `pwd`/certs:/certs -v /etc:/vm-etc -e DOMAIN=my-hostname -e PORT=5000 gesellix/inject-docker-certs

What's left? Running the registry. That's what this is all about, right?

    docker run --rm -it -p 5000:5000 -v `pwd`/certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/gesellix-mac:5000/cert.cert -e REGISTRY_HTTP_TLS_KEY=/certs/gesellix-mac:5000/cert.key registry:2
