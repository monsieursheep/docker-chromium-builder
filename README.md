## Build Image
```shell
docker build .
```

## Fetch & Build Chrome

```shell
user@host> docker run -it --rm -v /path/to/cr:/work docker-chromium-build:latest
root@docker> fetch android --nohooks [--no-history]
root@docker> cd src
root@docker> echo "target_os = [ 'android' ]" >> ../.gclient
root@docker> gclient sync
root@docker> gclient runhooks
root@docker> gn gen --args='target_os="android"' out/Default
root@docker> ninja -C out/Default chrome_public_apk chrome_modern_public_apk monochrome_public_apk
root@docker> ./out/Release/base_unittests
```
