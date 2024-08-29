#!/bin/bash

# Update package list
echo "Updating package list..."
sudo apt-get update -y

# Install Java (OpenJDK 17)
echo "Installing OpenJDK 17..."
sudo apt-get install -y openjdk-17-jre

# Add Jenkins repository and key
echo "Adding Jenkins repository..."
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list

# Update package list again to include Jenkins repository
echo "Updating package list with Jenkins repository..."
sudo apt-get update -y

# Install Jenkins
echo "Installing Jenkins..."
sudo apt-get install -y jenkins

# Start Jenkins service
echo "Starting Jenkins service..."
sudo systemctl start jenkins

# Enable Jenkins service to start on boot
echo "Enabling Jenkins to start on boot..."
sudo systemctl enable jenkins

# Optionally open the firewall port (default Jenkins port is 8080)
# Uncomment the lines below if you have UFW firewall enabled
# echo "Opening firewall port 8080..."
# sudo ufw allow 8080

# # Print Jenkins status
# echo "Jenkins installation complete."
# echo "Jenkins is running on http://localhost:8080"


# Install Docker
# Add Docker's official GPG key
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo chmod 666 /var/run/docker.sock
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu
sudo systemctl start docker

# Install Maven
# Maven will be updated automatically by the package manager
sudo apt-get update -y
sudo apt-get install maven -y
mvn -version

# Install Git
# Git will be updated automatically by the package manager
sudo apt-get update -y
sudo apt-get install git -y
git --version

# Enable Jenkins and Docker to start on boot
sudo systemctl enable jenkins
sudo systemctl enable docker

# Set up automatic updates for security patches
sudo apt-get install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades

# Install SonarQube
# Install unzip if not already installed
sudo apt-get install unzip -y

# Create a user for SonarQube
sudo adduser --disabled-password --gecos 'SonarQube' sonarqube

# Switch to SonarQube user and install SonarQube
sudo su - sonarqube <<EOF
# Fetch the latest SonarQube version from the official source
SONARQUBE_VERSION=$(curl -s https://api.github.com/repos/SonarSource/sonarqube/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
SONARQUBE_URL="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip"

# Download and extract SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip
unzip sonarqube-9.4.0.54424.zip
chmod -R 755 /home/sonarqube/sonarqube-9.4.0.54424
# Change ownership
chown -R sonarqube:sonarqube /home/sonarqube/sonarqube-9.4.0.54424
# Start SonarQube
cd sonarqube-9.4.0.54424/bin/linux-x86-64/
./sonar.sh start
EOF

echo "Installation complete. Jenkins, Docker, Maven, Git, and SonarQube are set up."








# # Install SonarQube
# # Install unzip if not already installed
# sudo apt-get install unzip -y

# # Create a user for SonarQube
# sudo adduser --disabled-password --gecos 'SonarQube' sonarqube

# # Switch to SonarQube user and install SonarQube
# sudo su - sonarqube <<EOF
# # Fetch the latest SonarQube version from the official source
# SONARQUBE_VERSION=$(curl -s https://api.github.com/repos/SonarSource/sonarqube/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
# SONARQUBE_URL="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip"

# # Download and extract SonarQube
# wget \$SONARQUBE_URL
# unzip sonarqube-${SONARQUBE_VERSION}.zip
# chmod -R 755 sonarqube-${SONARQUBE_VERSION}
# # Change ownership
# chown -R sonarqube:sonarqube sonarqube-${SONARQUBE_VERSION}
# # Start SonarQube
# cd sonarqube-${SONARQUBE_VERSION}/bin/linux-x86-64/
# ./sonar.sh start
# EOF