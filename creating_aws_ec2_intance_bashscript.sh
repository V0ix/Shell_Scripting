#!/bin/bash
<<aws
creating aws instance through this bash script 
aws

check_aws_cli(){
    if ! which aws &> /dev/null;
    then
    echo "AWS cli is not installed."
    return 1
    else
    echo "AWS cli is installed"
    fi
}

install_aws_cli() {
    echo "Installing AWS CLI v2 on Linux..."

    # Download and install AWS CLI v2
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    sudo apt-get install -y unzip &> /dev/null
    unzip -q awscliv2.zip
    sudo ./aws/install

    # Verify installation
    aws --version

    # Clean up
    rm -rf awscliv2.zip ./aws
}

wait_for_instance() {
    local instance_id="$1"
    echo "Waiting for instance $instance_id to be in running state..."

    while true; do
        state=$(aws ec2 describe-instances --instance-ids "$instance_id" --query 'Reservations[0].Instances[0].State.Name' --output text)
        if [[ "$state" == "running" ]]; then
            echo "Instance $instance_id is now running."
            break
        fi
        sleep 10
    done

    
        
}

create_ec2_instance() {
    local ami_id="$1"
    local instance_type="$2"
    local key_name="$3"
    local subnet_id="$4"
    local security_group_ids="$5"
    local instance_name="$6"

    # Run AWS CLI command to create EC2 instance
    instance_id=$(aws ec2 run-instances \
        --image-id "$ami_id" \
        --instance-type "$instance_type" \
        --key-name "$key_name" \
        --subnet-id "$subnet_id" \
        --security-group-ids "$security_group_ids" \
        --query 'Instances[0].InstanceId' \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
        --output text
    )

    if [[ -n "$instance_id" ]]; then
        echo -e "aws instance is created with some sort of description: \n ${instance_id}" >&2
    fi

    echo "aws instance is not  created."

    # Wait for the instance to be in running state
    wait_for_instance "$instance_id"
}


#driver program starts from here
main() {
    if !check_aws_cli; then
    install_aws_cli
    fi

    echo "Creating EC2 instance..."

    # Specify the parameters for creating the EC2 instance
    AMI_ID=""
    INSTANCE_TYPE="t2.micro"
    KEY_NAME="newKey"
    SUBNET_ID=""
    SECURITY_GROUP_IDS=""  # Add your security group IDs separated by space
    INSTANCE_NAME="vishal_first_instance_from_bash"

    # Call the function to create the EC2 instance
    create_ec2_instance "$AMI_ID" "$INSTANCE_TYPE" "$KEY_NAME" "$SUBNET_ID" "$SECURITY_GROUP_IDS" "$INSTANCE_NAME"

    echo "EC2 instance creation completed."
}
main "$@"
