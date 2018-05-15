#### Docker scripts for Glassfish v4

`Dockerfile` will create a Glassfish 4.1.2 Application Server image, downloading binaries from the internet and building the image.

```bash
docker build -t benwilcock/glassfish:4.1.2 .
```

When you run it you must supply your intended admin password...

```bash
docker run --name glassfish -ti -e ADMIN_PASSWORD=password -p 4848:4848 -p 8080:8080 -d benwilcock/glassfish:4.1.2
```

The admin console can be found on (https://localhost:4848)[https://localhost:4848]. the `username` is `admin` and the password is `password` (if you used the snippet above to start the container).

You can modify both the `Dockerfile` and the `docker-entrypoint.sh` to do more stuff like adding resources or deploying EAR's & WAR's etc.
Look inside the files for commented out bits. If your internet is slow, downloads the ZIP's manually and abandon the `curl` in the `Dockerfile`.
