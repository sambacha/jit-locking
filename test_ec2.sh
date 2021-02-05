
test_ec2() {
    # If we're not running on an EC2 instance, an empty body is returned
    # by this request:
    echo -n "Testing for being on EC2... "
    EC2_HOSTNAME=`curl --max-time 10 -s http://169.254.169.254/latest/meta-data/public-hostname || true`
    echo $DONE_MSG
}