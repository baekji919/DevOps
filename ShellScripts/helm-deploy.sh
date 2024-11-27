#!/bin/bash
if [[ $# == 1 || $# == 2 ]]; then
	services=("test" "test1" "test2")
	  script="../helm --kube-context=prod -n namespace -f ./prod.yaml"
    for i in "${services[@]}"
    do
      TAG="`aws ecr describe-images --repository-name production-$i-service --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' --output text | head -n 1`"
				script+="--set ecrImage.${i}Service=$TAG"
		echo "TAG :" $TAG
		echo "script: " $script
    done

    if [[ $1 == "reg" ]]; then
        export appVer="R-`date +'%y%m%d'`_090000"
        echo $appVer
    elif [[ $1 == "hot" ]]; then
        export appVer=$2
    fi

    echo "appver: $appVer"
else
    echo "helm-deploy.sh reg|hot TAG"
    exit
fi

cd /home/helm

sed -i "s/^appVersion: .*/appVersion: $appVer/g" Chart.yaml

echo $script
helm upgrade production $script --description $1