repo := docker.jiwiredev.com
docker-build-opt := --pull --force-rm
name := pca-mist

tag := mist-0.0.28
pca-scala-ver := 1.26
	 
	 
build:
	 docker build ${docker-build-opt} -t "${repo}/nined/${name}:${tag}" \
	 --build-arg PCA_SCALA_VER="${pca-scala-ver}" \
	 .

push:
	 docker push "${repo}/nined/${name}:${tag}"
	