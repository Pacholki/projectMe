import os
import pandas as pd

def combine_csv(csv_dir_path):

    dataframes_list = []
    csv_data_dir_path = os.path.join(csv_dir_path, "people")

    for csv_file in os.listdir(csv_data_dir_path):
        # print("working on file " + csv_file + "....")
        if csv_file.endswith('.csv'):
            csv_file_path = os.path.join(csv_data_dir_path, csv_file)
            current_data = pd.read_csv(csv_file_path)
            dataframes_list.append(current_data)

    combined_data = pd.concat(dataframes_list, ignore_index=True)

    combined_csv_file_name = "combined.csv"
    combined_csv_path = os.path.join(csv_dir_path, combined_csv_file_name)
    try:
        os.remove(path = combined_csv_path)
    except:
        pass
    combined_data.to_csv(combined_csv_path, index=False, encoding='utf-8')

    print(f"Combined {len(os.listdir(csv_data_dir_path))} CSV files and saved at: {combined_csv_path}")

if __name__ == "__main__":

    csv_dir_path = "csv_data"
    os.remove(os.path.join(csv_dir_path, "combined.csv"))
    combine_csv(csv_dir_path)
