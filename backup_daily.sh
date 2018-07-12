PROJECT=<xxxxxxxxxxxx>

gcloud config set project $PROJECT

date=`date +%Y-%m-%d-%H-%M-%S`

while IFS=',' read -r name disks zone; do
		echo "name: $name"
		echo "zone: $zone"

		IFS=';' read -ra diskArray <<< "$disks"
		for disk in "${diskArray[@]}"; do
		    echo "disk: $disk"
		    gcloud compute disks snapshot $disk --zone=$zone --snapshot-names $disk-$date --async
		donn
		echo "*******"
#for Linux vm disk 
done < <(gcloud compute instances list --format="csv[no-heading](name,disks.deviceName,zone)" --filter=labels.os=linux --project $PROJECT)

while IFS=',' read -r name disks zone; do
		echo "name: $name"
		echo "zone: $zone"

		IFS=';' read -ra diskArray <<< "$disks"
		for disk in "${diskArray[@]}"; do
		    echo "disk: $disk"
		    gcloud compute disks snapshot $disk --zone=$zone --guest-flush --snapshot-names $disk-$date --async  
		done	
		echo "*******"
#for Linux vm disk
done < <(gcloud compute instances list --format="csv[no-heading](name,disks.deviceName,zone)" --filter=labels.os=windows --project $PROJECT)
