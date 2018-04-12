## What next

```shell
$ export IMAGE_NAME=$USER/docker-chromium-builder
$ export CHROMIUM_SRC=~/chromium # or on Windows you need the full path c:\Users\<.....>\src
$ docker create -v $CHROMIUM_SRC:/src --name chromium_src $IMAGE_NAME /bin/true
$ docker run --rm -it --volumes-from=chromium_src $IMAGE_NAME
docker@7c56f908616f:/src$ ninja -C out/Release
docker@7c56f908616f:/src$ ./out/Release/base_unittests
```
