# Practice_in_design_and_development_of_information_systems

## Выполнение лабы:

docker compose -f docker-compose-cicd.yml up -d

http://localhost:8082/#login
http://localhost:8080/

docker exec -it nexus cat /nexus-data/admin.password
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword


docker exec -u 0 -it jenkins apt-get update && \
docker exec -u 0 -it jenkins apt-get install -y ansible sshpass


Установить плагины: Pipeline, Nexus Artifact Uploader, Ansible, Allure.
Настроить Credentials:
nexus-credentials (Username/Password для Nexus, admin/admin123).
ssh-credentials.

Создать Джобы:
Создать Pipeline Job "Build-App". В разделе Pipeline "Pipeline script from SCM" -> Git -> указать URL репозитория и путь jenkins/Jenkinsfile.build.
Создать Pipeline Job "Deploy-App". Аналогично, путь jenkins/Jenkinsfile.deploy

docker network connect lab3-ansible_ansiblenet jenkins

Прогнать джобы

http://localhost:8081/

Победа