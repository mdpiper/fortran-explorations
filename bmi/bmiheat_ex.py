"""An example of calling a Fortran BMI through Cython."""

from bmi_heat import Heat


config_file = ''

# Instantiate a model and get its name.
m = Heat()
print(m.get_component_name())

# Initialize the model.
m.initialize(config_file)

# List the model's echange items.
print('Input vars:', m.get_input_var_names())
print('Output vars:', m.get_output_var_names())

# Get time information from the model.
print('Start time:', m.get_start_time())
print('End time:', m.get_end_time())
print('Current time:', m.get_current_time())
print('Time step:', m.get_time_step())
print('Time units:', m.get_time_units())

# Advance the model by one time step.
m.update()
print('Current time:', m.get_current_time())

# Advance the model by a fractional time step.
m.update_frac(0.75)
print('Current time:', m.get_current_time())

# Advance the model until a later time.
m.update_until(10.0)
print('Current time:', m.get_current_time())

# Get the grid_id for the plate_surface__temperature variable.
var_name = 'plate_surface__temperature'
grid_id = m.get_var_grid(var_name)
print('Grid id for plate_surface__temperature:', grid_id)

# Get grid info for the plate_surface__temperature variable.
print(' - type:', m.get_grid_type(grid_id))
print(' - rank:', m.get_grid_rank(grid_id))
print(' - shape:', m.get_grid_shape(grid_id))
print(' - size:', m.get_grid_size(grid_id))
print(' - spacing:', m.get_grid_spacing(grid_id))
print(' - origin:', m.get_grid_origin(grid_id))

# Finalize the model.
m.finalize()

# Check that number of instances can't exceed N_MODELS=3.
# a = Heat()
# b = Heat()
# c = Heat()  # should fail with index=-1
