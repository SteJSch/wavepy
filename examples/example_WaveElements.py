from wavepy.standard_parameters import StdParameters

stdp = StdParameters(b_type='By')
print(f'stdp.b_type: {stdp.b_type}')
print(f'stdp.b_type.get(): {stdp.b_type.get()}')
stdp.b_type.set(1)
print(f'stdp.b_type.set(1): {stdp.b_type.get()}')
for child in stdp.children():
    print(child.name, child.get())