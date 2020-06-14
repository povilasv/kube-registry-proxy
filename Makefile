.PHONY: build

# IMAGE_NAME shall be used for kube-registry manifest.yml
IMAGE_NAME="kube-registry-proxy:0.1.0"

# Use --rm=false to reuse intermediate images
build:
	docker build -t $(IMAGE_NAME) -f Dockerfile --rm=false .
