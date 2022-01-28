 using CP;
 execute PARAMS{cp.param.TimeLimit = 60;}
 
{int} cars = ...;
{int} points = ... ;

tuple startData {int carId; int carStartPoint; int carStartTime; };
{startData} StartDateCar = ...; 
int startPointCats[cars] = [ i.carId : i.carStartPoint | i in StartDateCar ]; 
int startTimeCars[cars] = [ i.carId : i.carStartTime | i in StartDateCar ]; 

tuple shipmentData {int shipmentId; int startShipmentTime; int stratShipmentPoint; int shipmentDuration; int finishShipmentPoint; };
{shipmentData} Shipments = ... ;

{int} shipmentIds = {i.shipmentId | i in Shipments};

int stratShipmentTime[shipmentIds] = [ i.shipmentId : i.startShipmentTime | i in Shipments ];

int stratShipmentPoint[shipmentIds] = [ i.shipmentId : i.stratShipmentPoint | i in Shipments ];
int finishShipmentPoint[shipmentIds] = [ i.shipmentId : i.finishShipmentPoint | i in Shipments ];

int shipmentDuration[shipmentIds] = [ i.shipmentId : i.shipmentDuration | i in Shipments ];


//--------------------
tuple triplet {int id1; int id2; int value;};
{triplet} emptyTrainDistanceMatrix = ...;
//-------------------------------------

dvar interval StartInterval[c in cars] in startTimeCars[c]..startTimeCars[c] size 0;

dvar interval StartShippingInterval[c in cars][sp in shipmentIds] optional in stratShipmentTime[sp]..(stratShipmentTime[sp]+shipmentDuration[sp]) size shipmentDuration[sp];
dvar interval FinishShippingInterval[c in cars][sp in shipmentIds] optional;

//-----------------------------------
dvar sequence WagonSequence[c in cars] in 
	append(
	all(a in {c}) StartInterval[a],
	all(sp in shipmentIds) StartShippingInterval[c][sp],
	all(sp in shipmentIds) FinishShippingInterval[c][sp]
	)
types append(  
	all(a in {c}) startPointCats[a],
	all(sp in shipmentIds) stratShipmentPoint[sp],
	all(sp in shipmentIds) finishShipmentPoint[sp]
	);


maximize sum(c in cars, sp in shipmentIds) presenceOf (StartShippingInterval[c][sp]);

subject to
{
  
  
	forall(sp in shipmentIds)
		{
		  forall(c in cars)
		    {
		      	      
		      presenceOf(StartShippingInterval[c][sp]) == presenceOf(FinishShippingInterval[c][sp]);
		      prev(WagonSequence[c], StartShippingInterval[c][sp], FinishShippingInterval[c][sp]);
		    }
		    
		    sum (c in cars )presenceOf(StartShippingInterval[c][sp]) <= 1;
		    sum (c in cars )presenceOf(FinishShippingInterval[c][sp]) <= 1;
		}
			
			
	forall(c in cars)
		{
			noOverlap(WagonSequence[c], emptyTrainDistanceMatrix);	  
 		}	  
}