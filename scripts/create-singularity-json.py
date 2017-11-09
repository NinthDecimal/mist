import json
import sys
import os


def exclusive(singularity_config, hash_id, envoirment):
    singularity_config['deploy']['env']['MIST_WORKER_NAME'] = os.environ['MIST_WORKER_NAME']
    singularity_config['deploy']['env']['MIST_WORKER_CONTEXT'] = os.environ['MIST_WORKER_CONTEXT']

    singularity_config['deploy']['env']['MIST_WORKER_MODE'] = os.environ['MIST_WORKER_MODE']
    singularity_config['deploy']['env']['MIST_WORKER_JAR_PATH'] = os.environ['MIST_WORKER_JAR_PATH']
    singularity_config['deploy']['env']['MIST_WORKER_RUN_OPTIONS'] = os.environ['MIST_WORKER_RUN_OPTIONS']
    singularity_config['deploy']['env']['MIST_MASTER_IP'] = os.environ['MIST_MASTER_IP']

    singularity_config['id'] = singularity_config['id'] + '-' + envoirment + '-' + hash_id 
    
    return singularity_config
    

def main():
    
    hash_id = sys.argv[1]
    envoirment = sys.argv[2]
    
    template_json_path = "%s/configs/%s/pca-mist-worker.json" % (os.environ['MIST_HOME'], envoirment)
    
    with open(template_json_path) as template:
        singularity_config = json.load(template)
        exclusive_json = exclusive(singularity_config, hash_id, envoirment)
    
    print exclusive_json
    
    exclusive_json_path = "%s/configs/mist-worker-%s-%s.json" % (os.environ['MIST_HOME'], envoirment, hash_id)
    with open(exclusive_json_path, "wb") as f:
        f.write(json.dumps(exclusive_json,
                      indent=4, sort_keys=True,
                      separators=(',', ': '), ensure_ascii=False))
    
if __name__ == '__main__':
    main()
