# eks-airflow-celery
This repository is for my own educational purposes. 

It contains Terraform infrastructure definition, Docker image definition, GitHub action definition, and configuration to run [Apache Airflow](https://airflow.apache.org/) using the [Celery Executor](https://airflow.apache.org/docs/stable/executor/celery.html) with [RabbitMQ backend](https://docs.celeryproject.org/en/stable/getting-started/first-steps-with-celery.html#rabbitmq) on [AWS Elastic Kubernetes Service](https://aws.amazon.com/eks/). 

[Terraform Cloud](https://www.terraform.io/) manages infrastructure state.

[GitHub Actions](https://github.com/features/actions) builds the Docker image, and [GitHub Packages](https://github.com/features/packages) stores it.

Steps:
1. Get set up on [AWS Elastic Kubernetes Service](https://aws.amazon.com/eks/)

2. Create version control repository

3. Get set up on [Terraform Cloud](https://www.terraform.io/):
   - create account
   - create workspace
   - link the workspace to version control system repository
   - define variables

4. Push code to the version control repository to trigger a Terraform run which will:
    - create AWS resources
        - db subnet group and rds mysql database for airflow
    - create Kubernetes resources
        - namespace
        - rabbitmq deployment and service
        - flower deployment and service
        - airflow webserver deployment and service
        - airflow scheduler deployment
        - airflow worker deployment
        - ingress
            
5. Configure RabbitMQ users (more soon)

6. Configure DNS to access to the webserver and flower (more soon)
        
HELPFUL: 
    - https://github.com/puckel/docker-airflow

- TODO
    - route53 records via terraform https://www.terraform.io/docs/providers/aws/r/route53_record.html
    - rabbitmq initial user creation https://www.rabbitmq.com/access-control.html
    - database security group via terraform
    - airflow initial user creation https://airflow.apache.org/docs/stable/security.html
    - kubernetes executor / operator!