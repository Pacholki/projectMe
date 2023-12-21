import os
import pandas as pd

csv_dir_path = "csv_data"
print("at least it started")

combined_data = pd.DataFrame()

print("We are entering the loop")
for csv_file in os.listdir(csv_dir_path):
    print("working on file " + csv_file + "....")
    if csv_file.endswith('.csv'):
        csv_file_path = os.path.join(csv_dir_path, csv_file)
        current_data = pd.read_csv(csv_file_path)
        combined_data = combined_data.append(current_data, ignore_index=True)

# Save the combined DataFrame to a new CSV file
combined_csv_file_name = "combined.csv"
combined_csv_path = os.path.join(csv_dir_path, combined_csv_file_name)
combined_data.to_csv(combined_csv_path, index=False, encoding='utf-8')

print(f"Combined CSV file saved at: {combined_csv_path}")