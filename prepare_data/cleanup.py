import os

def remove_non_json(directory):

    contains_json = False

    for entry in os.listdir(directory):

        entry_path = os.path.join(directory, entry)

        if os.path.isfile(entry_path):
            if (entry_path.endswith(".json")):
                contains_json = True
            else:
                os.remove(entry_path)

        if os.path.isdir(entry_path):
            dir_with_json = remove_non_json(entry_path)
            # if dir_with_json:
            #     contains_json = True
            # else:
            #     os.remdir(entry_path)
        
    return contains_json


def contains_json(directory):

    for entry in os.listdir(directory):
        inner_dir = os.path.join(directory, entry)
        print(inner_dir)

if __name__ == "__main__":

    # data_dir = "json_data"
    data_dir = "json_data"
    print(remove_non_json(data_dir))