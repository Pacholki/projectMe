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
            return "0"
        return "1"
    
    csv_file_path = f"{out_path}/{dir_name}.csv"
    with open (csv_file_path, "w", newline="", encoding="latin-1") as csv_file:
        
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(["is_group", "sender_name", "timestamp", "content", "reactions", "photos", "videos"])

        for message in data['messages']:
            sender_name = message.get("sender_name", "")
            timestamp = message.get("timestamp_ms", "")
            content = message.get("content", "")

            reactions = ", ".join([reaction["reaction"] + "-" + reaction["actor"] for reaction in message.get("reactions", [])])
            photos = ', '.join([photo['uri'] for photo in message.get('photos', [])])
            videos = ', '.join([video['uri'] for video in message.get('videos', [])])

            csv_writer.writerow([is_group(), sender_name, timestamp, content, reactions, photos, videos])

def all_json2csv(base_dir, out_dir):

    try:
        os.mkdir(out_dir)
    except:
        pass

    for dir in os.listdir(base_dir):

        dir_path = os.path.join(base_dir, dir)

        if os.path.isdir(os.path.join(dir_path)):
            json2csv(dir_path, out_dir)
            # print("success, converted " + dir.split('_')[0])



if __name__ == "__main__":

    base_dir = "json_data/"
    out_dir = "csv_data/"

    all_json2csv(base_dir, out_dir)