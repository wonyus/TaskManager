package mq

import (
	"fmt"
	"log"
	"os"
	"strconv"
	"time"

	mqtt "github.com/eclipse/paho.mqtt.golang"
)

var connectHandler mqtt.OnConnectHandler = func(client mqtt.Client) {
	log.Println("Connected to MQTT broker")
}

var connectLostHandler mqtt.ConnectionLostHandler = func(client mqtt.Client, err error) {
	log.Printf("Connect to MQTT broker lost: %v", err)
}

func ConnectToMqttClient() mqtt.Client {
	broker := os.Getenv("MQTT_BROKER_URL")
	portStr := os.Getenv("MQTT_BROKER_PORT")
	port, err := strconv.Atoi(portStr)
	if err != nil {
		panic(err)
	}
	mqttClientID := os.Getenv("MQTT_BROKER_CLIENT_ID")
	mqttUsername := os.Getenv("MQTT_BROKER_USERNAME")
	mqttPassword := os.Getenv("MQTT_BROKER_PASSWORD")
	opts := mqtt.NewClientOptions()
	opts.AddBroker(fmt.Sprintf("tcp://%s:%d", broker, port))
	opts.SetClientID(mqttClientID)
	opts.SetUsername(mqttUsername)
	opts.SetPassword(mqttPassword)
	opts.OnConnect = connectHandler
	opts.OnConnectionLost = connectLostHandler
	opts.SetAutoReconnect(true)
	opts.SetCleanSession(true)
	opts.SetKeepAlive(time.Second * 60)
	client := mqtt.NewClient(opts)
	if token := client.Connect(); token.Wait() && token.Error() != nil {
		panic(token.Error())
	}
	return client
}
