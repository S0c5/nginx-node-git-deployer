# git-deployer
Set-up deploy system based on git for EC2 aws services and convert instance tags to env 
  


use the next command for setup the simple deployer

1.  GIT_DIR : Git directory
2.  APP_DOMAIN: application domain for use default: example.com
3.  APP_PORT: application port that will be used

```shell
    curl https://raw.githubusercontent.com/S0c5/nginx-node-git-deployer/master/setup.sh | bash -s GIT_DIR APP_DOMAIN APP_PORT
```


