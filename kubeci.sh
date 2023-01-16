#!/bin/bash
export GIT_VERSION=$(git rev-parse HEAD | cut -c1-8)

export NEW_IMAGE="sandervanvugt/kube-app:${GIT_VERSION}"
docker build -t ${NEW_IMAGE}
docker push ${NEW_IMAGE}

git clone https://github.com/sandervanvugt/kube-app
cd kube-app

kubectl patch --local -o yaml -f sampleginx-deploy.yaml \
-p "spec:
      template:
        spec:
          containers:
          - name: sampleginx
            image: ${NEW_IMAGE}" \
> /tmp/newsampleginx.yaml

mv /tmp/newsampleginx.yaml sampleginx.yaml

git commit sampleginx.yaml -m "CI update sampleginx image to ${NEW_IMAGE}"
git push


