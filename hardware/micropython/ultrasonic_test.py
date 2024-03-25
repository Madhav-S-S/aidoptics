from ultrasonic import measure_distance_1, measure_distance_2
import time

# Main loop
while True:
    dist_1 = measure_distance_1()
    print("Distance from Sensor 1:", dist_1, "cm")
    
    dist_2 = measure_distance_2()
    print("Distance from Sensor 2:", dist_2, "cm")
    
    time.sleep(1)  # Delay between each measurement
