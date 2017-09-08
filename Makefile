repo := docker.jiwiredev.com
docker-build-opt := --pull --force-rm
name := pca-mist

tag := mist-0.0.27
	 
	 
remove:
	 dockers-to-delete := $(docker images | grep ${repo}/nined/${name}:${tag} | awk '{ print $3 }') \
     docker rmi dockers-to-delete

build:
	 docker build ${docker-build-opt} -t "${repo}/nined/${name}:${tag}" \
	 .

push:
	 docker push "${repo}/nined/${name}:${tag}"
	