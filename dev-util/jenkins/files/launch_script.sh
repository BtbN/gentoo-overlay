#!/bin/bash

source /etc/conf.d/jenkins

if [ ! -n "$JENKINS_HOME" ]; then
	echo "JENKINS_HOME not configured"
	exit 1
fi

if [ ! -d "$JENKINS_HOME" ]; then
	echo "JENKINS_HOME directory does not exist: $JENKINS_HOME"
	exit 1
fi

if [ "$USER" != "jenkins" ] && [ -z "$IGNORE_USER" ]; then
	echo "Trying to launch jenkins as $USER instead of jenkins"
	exit 1
fi

JENKINS_WAR=/usr/lib/jenkins/jenkins.war
JAVA_PARAMS="$JENKINS_JAVA_OPTIONS -DJENKINS_HOME=$JENKINS_HOME -jar $JENKINS_WAR"

PARAMS="--logfile=/var/log/jenkins/jenkins.log"
[ -n "$JENKINS_PORT" ] && PARAMS="$PARAMS --httpPort=$JENKINS_PORT"
[ -n "$JENKINS_DEBUG_LEVEL" ] && PARAMS="$PARAMS --debug=$JENKINS_DEBUG_LEVEL"
[ -n "$JENKINS_HANDLER_STARTUP" ] && PARAMS="$PARAMS --handlerCountStartup=$JENKINS_HANDLER_STARTUP"
[ -n "$JENKINS_HANDLER_MAX" ] && PARAMS="$PARAMS --handlerCountMax=$JENKINS_HANDLER_MAX"
[ -n "$JENKINS_HANDLER_IDLE" ] && PARAMS="$PARAMS --handlerCountMaxIdle=$JENKINS_HANDLER_IDLE"
[ -n "$JENKINS_ARGS" ] && PARAMS="$PARAMS $JENKINS_ARGS"

if [ "$JENKINS_ENABLE_ACCESS_LOG" = "yes" ]; then
	PARAMS="$PARAMS --accessLoggerClassName=winstone.accesslog.SimpleAccessLogger --simpleAccessLogger.format=combined --simpleAccessLogger.file=/var/log/jenkins/access_log"
fi

exec $(java-config -J) $JAVA_PARAMS $PARAMS

