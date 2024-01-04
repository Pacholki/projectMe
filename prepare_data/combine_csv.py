import os
import pandas as pd

csv_dir_path = "csv_data"

dataframes_list = []

for csv_file in os.listdir(csv_dir_path):
    print("working on file " + csv_file + "....")
    if csv_file.endswith('.csv'):
        csv_file_path = os.path.join(csv_dir_path, csv_file)
        current_data = pd.read_csv(csv_file_path)
        current_data["receiver"] = [csv_file.split('.')[0]]
        dataframes_list.append(current_data)

combined_data = pd.concat(dataframes_list, ignore_index=True)

combined_csv_file_name = "combined.csv"
combined_csv_path = os.path.join(csv_dir_path, combined_csv_file_name)
combined_data.to_csv(combined_csv_path, index=False, encoding='utf-8')

print(f"Combined CSV file saved at: {combined_csv_path}")