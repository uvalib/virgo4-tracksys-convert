# set environment
export PATH=$PATH:/usr/local/openjdk-8/bin

# run application
java -cp "lib/*:lib_aws/*:dist/sqs_tracksys.jar" edu.virginia.lib.sqsserver.SQSQueueDriver --sqs-in ${VIRGO4_TRACKSYS_CONVERT_IN_QUEUE} --sqs-out ${VIRGO4_TRACKSYS_CONVERT_OUT_QUEUE} -s3 ${VIRGO4_SQS_MESSAGE_BUCKET}

#
# end of file
#
