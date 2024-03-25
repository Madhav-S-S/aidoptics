from machine import Pin
import time

# Define pin constants for first sensor
TRIG_PIN_1 = 1  # D0
ECHO_PIN_1 = 2  # D1

# Define pin constants for second sensor
TRIG_PIN_2 = 5  # D2
ECHO_PIN_2 = 4  # D3

# Initialize pins for first sensor
trigger_1 = Pin(TRIG_PIN_1, Pin.OUT)
echo_1 = Pin(ECHO_PIN_1, Pin.IN)

# Initialize pins for second sensor
trigger_2 = Pin(TRIG_PIN_2, Pin.OUT)
echo_2 = Pin(ECHO_PIN_2, Pin.IN)

# Function to measure distance for the first sensor
def measure_distance_1():
    # Triggering the ultrasonic sensor
    trigger_1.value(1)
    time.sleep_us(10)
    trigger_1.value(0)
    
    # Waiting for the echo pin to respond
    while echo_1.value() == 0:
        pulse_start = time.ticks_us()
    
    # Measuring the duration of the echo pulse
    while echo_1.value() == 1:
        pulse_end = time.ticks_us()
    
    # Calculating the duration of the echo pulse
    pulse_duration = pulse_end - pulse_start
    
    # Calculating distance in centimeters
    distance = (pulse_duration * 0.0343) / 2
    
    return distance

# Function to measure distance for the second sensor
def measure_distance_2():
    # Triggering the ultrasonic sensor
    trigger_2.value(1)
    time.sleep_us(10)
    trigger_2.value(0)
    
    # Waiting for the echo pin to respond
    while echo_2.value() == 0:
        pulse_start = time.ticks_us()
    
    # Measuring the duration of the echo pulse
    while echo_2.value() == 1:
        pulse_end = time.ticks_us()
    
    # Calculating the duration of the echo pulse
    pulse_duration = pulse_end - pulse_start
    
    # Calculating distance in centimeters
    distance = (pulse_duration * 0.0343) / 2
    
    return distance