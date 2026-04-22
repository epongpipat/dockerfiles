# dockerfiles

build docker
```
bash dockerfiles/bin/create_docker_and_simg.sh -s <software> -v <version> -o <output_dir>
```

## example
```
bash dockerfiles/bin/create_docker_and_simg.sh \
-s r \
-v 4.2.1 \
-o ~/mnt/cvl/kenrod/software/singularity_images
```