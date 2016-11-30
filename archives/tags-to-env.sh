######
# Author: Marcello de Sales (marcello.desales@gmail.com)
# Description: Create Create Environment Variables in EC2 Hosts from EC2 Host Tags
# 
### Requirements:  
# * Install jq library (sudo apt-get install -y jq)
# * Install the EC2 Instance Metadata Query Tool (http://aws.amazon.com/code/1825)
#
### Installation:
# * Add the Policy EC2:DescribeTags to a User
# * aws configure
# * Souce it to the user's ~/.profile that has permissions
#### 
# Add tags to an EC2 host or Image Profile
# Reboot and verify the result of $(env).

# Loads the Tags from the current instance
getInstanceTags () {
  # http://aws.amazon.com/code/1825 EC2 Instance Metadata Query Tool
  INSTANCE_ID=$(/usr/local/bin/ec2-metadata | grep instance-id | awk '{print $2}')

  # Describe the tags of this instance
  aws ec2 describe-tags --region us-west-2 --filters "Name=resource-id,Values=$INSTANCE_ID"
}

# Convert the tags to environment variables.
# Based on https://github.com/berpj/ec2-tags-env/pull/1
tags_to_env () {
    tags=$1

    for key in $(echo $tags | /usr/bin/jq -r ".[][].Key"); do
        value=$(echo $tags | /usr/bin/jq -r ".[][] | select(.Key==\"$key\") | .Value")
        key=$(echo $key | /usr/bin/tr '-' '_' | /usr/bin/tr '[:lower:]' '[:upper:]')
#        echo "Exporting $key=$value"
        export $key="$value"
    done
}

# Execute the commands
instanceTags=$(getInstanceTags)
tags_to_env "$instanceTags"
