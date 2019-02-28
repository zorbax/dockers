#!/usr/bin/env python3

'''
This version of KmerFinder only allows for 1 or 2 input files, though the options for more exist.
If two files are given as input, it will check the filenames to see if they are the same to infer
if these are paired end/mate paired. If filenames differ, it exits with error status.
'''

#######################
## Import libraries  ##
#######################
import sys
import os
import datetime
import time
import argparse
import subprocess
import json, gzip, pprint, shutil
try:
    from subprocess import DEVNULL  # Python 3.
except ImportError:
    DEVNULL = open(os.devnull, 'wb')

	
################
##  FUNCTIONS ##
################

def start_subprocess(cmd):
    """Run cmd (a list of strings) and return a Popen instance."""
    return subprocess.Popen(cmd, shell = True, stdout=DEVNULL, stderr=DEVNULL)
    
def check_infiles_num(infiles):
    ''' Infiles must be a list with 1 or 2 input files.
        Extracts the common sample name if 2 files are given, to check if paired end.
    '''

    seq_path = infiles[0]
    seq_file = os.path.basename(seq_path)
    seq_file = seq_file.replace(".fq", "")
    seq_file = seq_file.replace(".fastq", "")
    seq_file = seq_file.replace(".gz", "")
    seq_file = seq_file.replace(".trim", "")
    seq_file = seq_file.split(".")[0].split("_")
    seq_file = seq_file[0]
    # If two files are given get the common sample name
    sample_name = ""
    seq_file_2 = os.path.basename(infiles[1])
    for i in range(len(seq_file)):
        if seq_file_2[i] == seq_file[i]:
            sample_name += seq_file[i]
        else: 
            break
    if sample_name == "" or sample_name != seq_file:
        print("Input error: sample names of input files, {} and {}, do not share a common sample name. If files are paired end reads from the same sample, please rename them with a common sample name (e.g. 's22_R1.fq', 's22_R2.fq OR 's22.R1.fq', 's22.R2.fq'). Else, input them seperately.".format(infiles[0], infiles[1]));
        sys.exit(1)         

    return True

def check_zipped(filename):
    """
    Checks if file is gzipped, or has .zip format description. If file is .zip
    it exits with error.
    """
    format=""
    try:
        with open(filename, 'rb') as fh:
            file_type = fh.read(2)
    except IOError as err:
        print("Cant open file:", str(err));
        sys.exit(1)
    if file_type == b'\x1f\x8b':
        format = "gzip"
        return format
    elif file_type == b'PK':
        print("Input error: file {}: File has Zip (.zip) format description. Please compress your file(s) with Gzip format instead.".format(filename))
        sys.exit(1)  
      
           
def get_file_format(input_files):
    """
    Takes all input files and checks their first character to assess
    the file format. Returns one of the following strings; fasta, fastq, 
    other or mixed. fasta and fastq indicates that all input files are 
    of the same format, either fasta or fastq. Otherwise, it indiates that not all
    files are fasta or fastq files. mixed indicates that the inputfiles
    are a mix of different file formats.
    """

    # Open all input files and get the first character
    file_format = []
    invalid_files = []
    for infile in input_files:
        ## Here check if zipped
        format = check_zipped(infile)
        if format =="gzip":
            try:
                f = gzip.open(infile, "rb")
                fst_char = f.read(1);
            except IOError as err:
                print("Cant open file:", str(err));
                sys.exit(1)
        else:
            try:
                f = open(infile, "rb")
            except IOError as err:
                print("Cant open file:", str(err));
                sys.exit(1)
            
            fst_char = f.read(1);
        f.close()
        # Assess the first character
        if fst_char == b"@":
            file_format.append("fastq")
        elif fst_char == b">":
            file_format.append("fasta")
        else:
            invalid_files.append("other")
    if len(set(file_format)) > 1:
        return "mixed"
    return ",".join(set(file_format))

#################################
##  PARSE COMMANDLINE OPTIONS  ##
#################################

if __name__ == "__main__":
    start_time = time.time()
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--infile',  help="FASTA(.gz) or FASTQ(.gz) file(s) to run KmerFinder on.", nargs='+')
    parser.add_argument('-batch', '--batch_file',  help="OPTION NOT AVAILABLE:file with multipe files listed")  # only for local download 
    parser.add_argument('-o', '--output_folder',  help="folder to store the output", default='output')
    parser.add_argument('-db', '--db_path',  help="path to database and database file") 
    parser.add_argument('-db_batch', '--db_batch',  help="OPTION NOT AVAILABLE:file with paths to multiple databases") # only for local download -- not implemented yet
    # parser.add_argument('-kma', '--kma_arguments',  help="Extra arguments for KMA", nargs='+',action=MyAction)
    parser.add_argument('-kma', '--kma_arguments',  help="OPTION NOT AVAILABLE:Extra arguments for KMA", type=str)
    # parser.add_argument('-web','--web_server_mode', action='store_true')
    parser.add_argument('-tax', '--tax',  help="taxonomy file with additional data for each template in all databases (family, taxid and organism)")
    parser.add_argument("-x", "--extended_output",  help="Give extented output with taxonomy information", action="store_true")
    parser.add_argument("-kp", "--kma_path",    help="Path to kma program")
    parser.add_argument("-q", "--quiet", action="store_true")
    args = parser.parse_args()

    if args.quiet:
        f = open('/dev/null', 'w')
        sys.stdout = f
    # Make input file list
    input_list = list()
    if args.batch_file != None:
        try:
            with open(args.batch_file, "r") as i:
                for line in i:
                    input_list.append(line.rstrip())
        except IOError as err:
            print("Cant open file:", str(err));
            sys.exit(1) 
    elif args.infile != None: 
        if len(args.infile) < 2:
            input_list.append("%s"%(args.infile[0]))
        else:
            multiple_infile = ' '.join(args.infile)
            input_list.append(multiple_infile) 
    else:
        print("Error: Please specify input file(s)!\n")
        sys.exit(2)
        
    if args.extended_output != None:
        extended_output = args.extended_output
        
    # Check if method path is executable
    if args.kma_path != None:
        kma_path = args.kma_path  
    else:
        kma_path = "kma"
        if shutil.which(kma_path) == None:
            sys.exit("Error: No valid path to a kma program was provided. Use the -kp flag to provide the path.")
        else:
            kma_path = ""
    # Check if extra arguments for kma were given
    if args.kma_arguments != None: 
        kma_args = ' '.join(args.kma_arguments)
        
    # Create output folder
    try:
       out_folder = args.output_folder
       os.system("mkdir -p %s"%(out_folder))
    except:
       print("Error: Problem with output folder (option -out)!\n")
       sys.exit(2)

    # Get database(s)
    db_list = list()
    if args.db_batch != None:
       with open(args.db_batch, "r") as i:
          for line in i:
             db_list.append(line.rstrip())
    elif args.db_path != None:
       db_list.append(args.db_path)
    else:
       print("Error: Please specify a database!\n")
       sys.exit(2)

    # Get taxonomy class of database used
    organism = os.path.basename(args.db_path).split(".")[0]
       
       
    ############################################
    ##	MAIN - COLLECT AND CHECK INPUT FILES  ##
    ############################################

    # Collect input file(s)
    infile = list()    
    for input in input_list:
        infile.extend(input.split())

    # Get file format of input file(s)
    file_format = get_file_format(infile)

    # Check file format, and accepted number of input files
    if file_format == "fastq":
        if len(infile) == 2:
            check_names = check_infiles_num(infile)
        elif len(infile) > 2:
            sys.exit("Error: Only 2 input files accepted for raw read data, if data from more runs is available for the same sample, please concatenate the reads into two files")
        
    elif file_format == "fasta":
        try:
            fastafiles = len(infile)
            if fastafiles != 1:
                raise ValueError("Only one input file accepted for assembled data in fasta format.")
        except ValueError as error:
            print(str(error))
       
    else:
        sys.exit("Error: Input file(s) must be fastq or fasta format, not "+ file_format)

    #############################
    ##  MAIN - RUN KMERFINDER  ##
    #############################

    for input in input_list:
        for db in db_list:
            db_name = db.split("/")[-1]
            if args.kma_arguments != None:
                cmd = "%skma -i %s -o %s/results -t_db %s -Sparse %s"%(kma_path, input, out_folder, db,kma_args) # make it a list
            else:
                cmd = "%skma -i %s -o %s/results -t_db %s -Sparse"%(kma_path, input, out_folder, db) # make it a list
            #print("CMD:",cmd)
            process = subprocess.Popen(cmd.split(" "), shell=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE) 
            out, err = process.communicate()

       
    print("# Time used to run KMA for species identifation: " + str(round(time.time()- start_time, 3)) + " s")

    ############################################
    ## MAIN - Get taxonomic info for results  ##
    ############################################

    # If option for taxonomy is chosen and taxonomy file is given, create results file with additional taxonomic info on the hits of KMA
    if args.tax != None:
        # Store taxonomy in dictionary
        try:
            taxfile = open(args.tax,"r")
        except IOError as err:
            print("Cant open file:", str(err));
            sys.exit(1)
            
        tax={}
        tax_type=""
        count = 0
        for l in taxfile:
            l=l.strip()
            l=l.split("\t")
            l1 =l[0].split(" ",1)
            l=l1 +l[1:]
            if count==1:
                tax_len = len(l)
                if tax_len >= 5:
                    tax_type = "bac"
            
            tax[l[0]] = "\t".join(l[1:])
            count += 1
        
        taxfile.close()
        # parse output from KMA and find taxonomy info
        kma_res_file = out_folder + "/results.spa"
        try:
            infile = open(kma_res_file,"r")
        except IOError as err:
            print("Cant open file:", str(err));
            sys.exit(1)
            
        # Open output file for writing
        resultsTaxFilename = out_folder + "/results.txt"
        try:
            outfile = open(resultsTaxFilename,"w")
        except IOError as err:
            print("Cant open file:", str(err));
            sys.exit(1)
            
        for l in infile:
            l=l.strip()
            if l[0] == "#":
                header = l.split("\t")
                header = "\t".join(header[1:])
                if tax_type == "bac":
                    header="# Assembly\t" + header + "\tAccession Number\tDescription\tTAXID\tTaxonomy\tTAXID Species\tSpecies\n"
                else:
                    header="# Assembly\t" + header + "\tAccession Number\tDescription\tTAXID\tTaxonomy\n"
                head = header.split("\t")
                outfile.write(header)
            else:
                hit = l.split("\t")
                # Split first item to separate accession number and description
                hit1 = hit[0].split(" ",1)
                hit = hit1 + hit[1:]
                # Collect results from KMA, except from template
                res_kma = "\t".join(hit[2:])
                # Get accession id and description
                res_accId = hit[0]
                res_desc = hit[1]
                # Check if result hit from KMA in taxonomy    
                if res_accId in tax:
                    t=tax[res_accId]
                    t = t.split("\t")
                    # Get assembly name from  and description
                    res_assem = t[1]
                    # Get final taxonomy results match, emit assembly name
                    t = "\t".join(t[2:])
                    results_tax = res_assem + "\t" + res_kma + "\t" + res_accId + "\t" + res_desc + "\t" + t + "\n"
                    
                else:
                    # if options.bacteria == True:
                    if tax_type == "bac":
                        t="unknown\tunknown\tunknown\tunknown"
                    else:
                        t="unknown\tunknown"
                    results_tax = "unknown\t" + res_kma + "\t" + res_accId + "\t" + res_desc + "\t" + t + "\n"

                outfile.write(results_tax)

        infile.close()
        outfile.close()

    # Get run info for JSON file
    service = os.path.basename(__file__).replace(".py", "")
    date = time.strftime("%d.%m.%Y")
    time = time.strftime("%H:%M:%S")

    if extended_output:
        result_file = "{}/results.txt".format(out_folder) 
    else:
        result_file = "{}/results.spa".format(out_folder) 


    # Open results file from KmerFinder    
    try:
        spa = open(result_file, 'r')    
    except IOError as err: 
        print("Error: Cant open results file:" + str(err) + '\n')
        sys.exit(1)
    except IndexError as err:
        print("Error: No results file was produced from KmerFinder! " + '\n')
        exit(1)

    # Create json object
    header = list()
    hits = {}

    for line in spa:
        if line.startswith('#'):
            header.extend(line.split('\t'))
            header[0] = header[0].replace("#", "").strip()
            header[-1] = header[-1].strip()
        else:
            lineSplit = line.split('\t')
            hitDict = dict()
            #Create dictionary with this hit
            for i in range(len(lineSplit)):
                hitDict[header[i]] = lineSplit[i].strip()
            # Add to bigger dictionary for all hits
            if not extended_output:
                hits[lineSplit[0].strip()] = hitDict 
            else:
                hits[lineSplit[14].strip()] = hitDict   
    spa.close()

    # Collect all data of run-analysis
    data = {service:{}}
    userinput = {"filename":args.infile, "database":organism,"file_format":file_format}
    run_info = {"service":service, "version":3.0, "date":date, "time":time}#, "database":{"remote_db":remote_db, "last_commit_hash":head_hash}}
    server_results = {"species_hits":hits}

    data[service]["user_input"] = userinput
    data[service]["run_info"] = run_info
    data[service]["results"] = server_results

    pprint.pprint(data)

    # Save json output
    result_json_file = "{}/data.json".format(out_folder) 
    with open(result_json_file, "w") as outfile:  
        json.dump(data, outfile)
