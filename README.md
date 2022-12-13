# Assgn1

	Creation of S3 bucket
	
	Creation of bucket for non prod environment

	Once Bucket is created refer it to the respective environment
	
	cd /home/ec2-user/environment/130377229_assignment1/root/nonprod/network_nonprod/config.tf
	cd /home/ec2-user/environment/130377229_assignment1/root/nonprod/webserver_nonprod/config.tf
	cd /home/ec2-user/environment/130377229_assignment1/root/prod/network_prod/config.tf
	cd /home/ec2-user/environment/130377229_assignment1/root/prod/webserver_prod/config.tf
	
	both bucket name should be referenced in peeringbase environment for prod and non prod
	cd /home/ec2-user/environment/130377229_assignment1/root/peeringbase/main.tf
	cd /home/ec2-user/environment/130377229_assignment1/root/nonprod/webserver_nonprod/main.tf
	cd /home/ec2-user/environment/130377229_assignment1/root/prod/webserver_prod/main.tf
	
	Creation of keys
	cd /home/ec2-user/environment/130377229_assignment1/root/nonprod/webserver_nonprod/
	cd /home/ec2-user/environment/130377229_assignment1/root/prod/webserver_prod/
	
	ssh -keygen -t rsa assignment1
	ssh -keygen -t rsa assignment1-prodkey1
	
	Deployment in following order
	cd /home/ec2-user/environment/130377229_assignment1/root/nonprod/network_nonprod/
	tf init 
	tf validate
	tf fmt
	tf plan
	tf apply -auto-approve
	
	cd /home/ec2-user/environment/130377229_assignment1/root/nonprod/webserver_nonprod/
	tf init 
	tf validate
	tf fmt
	tf plan
	tf apply -auto-approve
	
	cd /home/ec2-user/environment/130377229_assignment1/root/prod/network_prod/
	tf init 
	tf validate
	tf fmt
	tf plan
	tf apply -auto-approve
	
	cd /home/ec2-user/environment/130377229_assignment1/root/prod/webserver_prod/
	tf init 
	tf validate
	tf fmt
	tf plan
	tf apply -auto-approve
	
	cd /home/ec2-user/environment/130377229_assignment1/root/peeringbase/
	tf init 
	tf validate
	tf fmt
	tf plan
	
	Destruction in following order
		cd /home/ec2-user/environment/130377229_assignment1/root/peeringbase/
		tf destroy
		
		cd /home/ec2-user/environment/130377229_assignment1/root/prod/webserver_prod/
		tf destroy
		
		cd /home/ec2-user/environment/130377229_assignment1/root/prod/network_prod/
		tf destroy
		
		cd /home/ec2-user/environment/130377229_assignment1/root/nonprod/webserver_nonprod/
		tf destroy
		
		cd /home/ec2-user/environment/130377229_assignment1/root/nonprod/network_nonprod/
		tf destroy
		
	
	
