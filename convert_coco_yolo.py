from __future__ import print_function
# best model until now
import argparse
import glob
import os
import sys
import json

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "path", help='Directory of json files containing annotations')
    parser.add_argument(
        "output_path", help='Output directory for image.txt files')
    parser.add_argument("--debug", action="store_true")
    args = parser.parse_args()
    json_files = sorted(glob.glob(os.path.join(args.path, '*.json')))
    if args.debug:
        total_count = 0
        cats = {0: 0, 1: 0, 2: 0}
        bike_images = set()
    for json_file in json_files:
        with open(json_file) as f:
            data = json.load(f)
            image = data['image']
            annotations = data['annotation']
            file_name = image['file_name']
            width = float(image['width'])
            height = float(image['height'])
            converted_results = []
            for ann in annotations:
                cat_id = int(ann['category_id'])
                if cat_id <= 3:
                    left, top, bbox_width, bbox_height = map(
                        float, ann['bbox'])

                    # Yolo classes are starting from zero index
                    cat_id -= 1
                    if args.debug:
                        cats[cat_id] += 1
                        total_count += 1
                        if cat_id == 1:
                            bike_images.add(file_name)
                    x_center, y_center = (
                        left + bbox_width / 2, top + bbox_height / 2)
                    # darknet expects relative values wrt image width&height
                    x_rel, y_rel = (x_center / width, y_center / height)
                    w_rel, h_rel = (bbox_width / width, bbox_height / height)
                    converted_results.append(
                        (cat_id, x_rel, y_rel, w_rel, h_rel))
            if not args.debug:
                with open(os.path.join(args.output_path, file_name + '.txt'), 'w+') as fp:
                    fp.write('\n'.join('%d %.6f %.6f %.6f %.6f' %
                                       res for res in converted_results))
    if args.debug:
        print({cat: cats[cat] for cat in cats})
        print(total_count)
        with open('bikes.txt', 'a+') as f:
            f.write('\n'.join("data/thermal/%s.jpeg"%b_img for b_img in bike_images))
            f.write('\n')
