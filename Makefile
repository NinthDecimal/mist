repo := docker.jiwiredev.com
docker-build-opt := --pull --force-rm
name := pca-mist

tag := mist-0.0.19

build:
	docker build ${docker-build-opt} -t "${repo}/nined/${name}:${tag}" \
		.

push:
	docker push "${repo}/nined/${name}:${tag}"
	