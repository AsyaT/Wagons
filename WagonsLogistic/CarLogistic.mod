 using CP;
 execute PARAMS{cp.param.TimeLimit = 60;}
 
{int} cars = ...;
{int} points = ... ;

tuple startData {int carId; int carStartPoint; int carStartTime; };
{startData} StartDateCar = ...; 
int startPointCats[cars] = [ i.carId : i.carStartPoint | i in StartDateCar ]; 
int startTimeCars[cars] = [ i.carId : i.carStartTime | i in StartDateCar ]; 

tuple shipmentData {int shipmentId; int startShipmentTime; int stratShipmentPoint; int shipmentDuration; int finishShipmentPoint; int driveDuration; };
{shipmentData} Shipments = ... ;
{int} shipmentIds = {i.shipmentId | i in Shipments};

int stratShipmentTime[shipmentIds] = [ i.shipmentId : i.startShipmentTime | i in Shipments ];

int stratShipmentPoint[shipmentIds] = [ i.shipmentId : i.stratShipmentPoint | i in Shipments ];
int finishShipmentPoint[shipmentIds] = [ i.shipmentId : i.finishShipmentPoint | i in Shipments ];

int shipmentDuration[shipmentIds] = [ i.shipmentId : i.shipmentDuration | i in Shipments ];
int shipmentDriveDuration[shipmentIds] = [ i.shipmentId : i.driveDuration | i in Shipments ];

//--------------------
tuple triplet {int id1; int id2; int value;};
{triplet} emptyTrainDistanceMatrix = ...;
//-------------------------------------

dvar interval StartInterval[c in cars] in startTimeCars[c]..startTimeCars[c] size 0;

dvar interval StartShippingInterval[c in cars][sp in Shipments] optional in stratShipmentTime[sp]..stratShipmentTime[sp] size shipmentDuration[cp];
dvar interval FinishShippingInterval[c in cars][sp in Shipments] optional size shipmentDriveDuration[sp];

//-----------------------------------
dvar sequence WagonSequence[c in cars] in 
	append(
	StartInterval[c],
	all(sp in Shipments) StartShippingInterval[c][sp],
	all(sp in Shipments) FinishShippingInterval[c][sp]
	)
types append(  
	startPointCats[c],
	all(sp in Shipments) stratShipmentPoint[sp],
	all(sp in Shipments) finishShipmentPoint[sp]
	);


maximize sum(c in cars, sp in points) presenceOf (StartShippingInterval[c][sp]);

subject to
{
  
  
	forall(sp in points)
		{
		  forall(c in cars)
		    {
		      presenceOf(StartShippingInterval[c][sp] == FinishShippingInterval[c][sp]);
		      endAtStart (StartShippingInterval[c][sp],FinishShippingInterval[c][sp]);
		    }
			 sum (c in cars )presenceOf(Shippment[c][sp]) <= 1; // ??????
		}
			
			
	forall(c in cars)
		{
			noOverlap(WagonSequence[c], emptyTrainDistanceMatrix);	  
 		}	  
}