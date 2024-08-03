from ParticleSwarmOptimizer import *
from Utility import *
from BinPacking import *
folder_path='InstanceSets/InstanceSet1/'
instance_name = "cl_01_020_09"
plot_path = 'Plot/' + instance_name
def execute_algorithm(dataset):
    print(f"- dataset: {dataset}")
    bin_width, bin_height, rectangles = read_items(folder_path + dataset)
    optimizer = PSO(config["num_particles"],config["max_iteration"], rectangles, config["w"], config["c1"], config["c2"], bin_width, bin_height)
    optimizer.run()
    print(f"- min bins: {len(optimizer.gbest.positions)}")
    visualize_bins(optimizer.gbest.positions, 'Plot/'+dataset, 1)
#     plot_objectives(optimizer.best_objectives, optimizer.avg_objectives,  'Plot/'+dataset)
    print("-"*30)
    return optimizer
config = read_config('Config/PSO.json')
# datasets = read_excel()
datasets = [instance_name]
for i in range(1): 
    bins_size = []
    execution_times = []
    for j, dataset in enumerate(datasets):
        optimizer = execute_algorithm(dataset)
#         bins_size.append(len(optimizer.best_solution))
    # write_excel_bins(bins_size)
    print(f" ------------------------- run number: {i + 1} ----------------------------")