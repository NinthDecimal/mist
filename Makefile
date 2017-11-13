repo := docker.jiwiredev.com
docker-build-opt := --pull --force-rm

dev-name := pca-mist-dev
stage-name := pca-mist-stage
qa-name := pca-mist-qa
integration-name := pca-mist-integration
prod-name := pca-mist-prod

tag := 0.13.2
pca-scala-ver := 1.30
	 
	 
build-dev:
	 docker build ${docker-build-opt} -t "${repo}/nined/${dev-name}:${tag}" \
	 --build-arg PCA_SCALA_VER="${pca-scala-ver}" \
	 .

push-dev:
	 docker push "${repo}/nined/${dev-name}:${tag}"
	 
build-stage:
	 docker build ${docker-build-opt} -t "${repo}/nined/${stage-name}:${tag}" \
	 --build-arg PCA_SCALA_VER="${pca-scala-ver}" \
	 .

push-stage:
	 docker push "${repo}/nined/${stage-name}:${tag}"

build-qa:
	 docker build ${docker-build-opt} -t "${repo}/nined/${qa-name}:${tag}" \
	 --build-arg PCA_SCALA_VER="${pca-scala-ver}" \
	 .

push-qa:
	 docker push "${repo}/nined/${qa-name}:${tag}"

build-integration:
	 docker build ${docker-build-opt} -t "${repo}/nined/${integration-name}:${tag}" \
	 --build-arg PCA_SCALA_VER="${pca-scala-ver}" \
	 .

push-integration:
	 docker push "${repo}/nined/${integration-name}:${tag}"

build-prod:
	 docker build ${docker-build-opt} -t "${repo}/nined/${prod-name}:${tag}" \
	 --build-arg PCA_SCALA_VER="${pca-scala-ver}" \
	 .

push-prod:
	 docker push "${repo}/nined/${prod-name}:${tag}"

#make build-dev push-dev build-stage push-stage build-qa push-qa build-integration push-integration build-prod push-prod
