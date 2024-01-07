import os 
import json
import csv

def json2csv(dir_path, out_path):

    
    dir_name = os.path.basename(dir_path).split('_')[0]

    json_file_path = os.path.join(dir_path, "message_1.json")
    with open(json_file_path, "r", encoding="latin-1") as json_file:
        data = json.load(json_file)
    
    participant_count = len(data["participants"])
    
    def is_group():
        if participant_count == 2:
            return False
        return True

    def get_receiver_name(sender_name):

        if is_group():
            return dir_name
        
        for participant in data["participants"]:
            if participant["name"] != sender_name:
                return participant["name"]
        return None

    def count_words(message):
        return len(message.split(" "))

    def get_csv_file_path():

        csv_file_path = f"{out_path}/{dir_name}.csv"

        names_taken = 0
        while (os.path.exists(csv_file_path)):

            file_name = csv_file_path[:-4]
            if (names_taken):
                suffix = len(str(names_taken)) + 1
                file_name = file_name[:-suffix]

            names_taken += 1
            csv_file_path = file_name + "-" + str(names_taken) + csv_file_path[-4:]

        return csv_file_path

    csv_file_path = get_csv_file_path()

    with open (csv_file_path, "w", newline="", encoding="latin-1") as csv_file:
        
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(["is_group", "sender_name", "receiver_name", "timestamp", "content", "char_count", "word_count", "reactions", "photo_ext", "video_ext", "reaction_count", "photo_count", "video_count"])

        for message in data['messages']:
            sender_name = message.get("sender_name", "")
            receiver_name = get_receiver_name(sender_name=sender_name)

            timestamp = message.get("timestamp_ms", "")
            content = message.get("content", "")
            char_count = len(content)
            word_count = count_words(content)

            reactions = ", ".join([reaction["reaction"] + "-" + reaction["actor"] for reaction in message.get("reactions", [])])
            photo_ext = ', '.join([photo['uri'][-3:] for photo in message.get('photos', [])])
            video_ext = ', '.join([video['uri'][-3:] for video in message.get('videos', [])])
            reaction_count = len(message.get("reactions", []))
            photo_count = len(message.get("photos", []))
            video_count = len(message.get("videos", []))

            csv_writer.writerow([is_group(), sender_name, receiver_name, timestamp, content, char_count, word_count, reactions, photo_ext, video_ext, reaction_count, photo_count, video_count])

def all_json2csv(base_dir, out_dir):

    try:
        os.mkdir(out_dir)
    except:
        pass

    os.makedirs(out_dir, exist_ok = True)
    for item in os.listdir(out_dir):
        os.remove(os.path.join(out_dir, item))

    for dir in os.listdir(base_dir):

        dir_path = os.path.join(base_dir, dir)

        if os.path.isdir(dir_path):
            json2csv(dir_path, out_dir)
            # print("success, converted " + dir.split('_')[0])

    print(f"{len(os.listdir(out_dir))} files converted from JSON to CSV")



if __name__ == "__main__":

    base_dir = "json_data/"
    out_dir = "csv_data/people/"

    all_json2csv(base_dir, out_dir)