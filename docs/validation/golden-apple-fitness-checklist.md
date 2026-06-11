# Golden Apple Fitness Validation Checklist

Apple Fitness is the manual visual reference for this milestone. HealthKit remains RunSignal's source data. Do not validate against FIT files or the old web dashboard.

Use the in-app Data -> Apple Fitness Validation screen after loading real HealthKit data on the physical iPhone. Share the generated checklist and JSON fixture, then fill the fixture from Apple Fitness.

For each selected workout, copy:

- Distance
- Workout time
- Elapsed time
- Average pace
- Active calories
- Total calories
- Average heart rate
- Max heart rate if visible
- Elevation gain
- Cadence
- Power
- Route available yes/no
- Splits, only for the smaller split-validation subset

Default tolerances:

- Distance: within 0.5% or 20 meters, whichever is larger
- Workout duration: within 2 seconds
- Elapsed time: within 2 seconds
- Average pace: within 3 seconds per km
- Active calories: within 3%
- Total calories: within 3%
- Average HR: within 2 bpm
- Max HR: within 2 bpm
- Elevation gain: within 5 meters or 10%, whichever is larger
- Cadence: within 2 spm
- Power: within 5 watts or 3%, whichever is larger

Label this validation: High-confidence Apple Fitness parity validation. Do not label it scientific or lab-grade validation.
