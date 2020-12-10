 using CP;
  execute PARAMS{cp.param.TimeLimit = 60;}
 
{int} wagons = ...;
{int} shipmentPoint = ... ;
{int} startPoint = ...;

int startPointStartDateWagon[wagons] = ...; // ����� ������ ������ ��� ������� ������
int pointOfStart[wagons] = ...;

int shippmentStartDate[shipmentPoint] = ...; // ���� ����������� ��������� �����
int shippmentDuration[shipmentPoint] = ...;//������� ����� � ���� �� ����������� ��������� �����

int emptyTrainStartDuration [startPoint] [ shipmentPoint] = ...;
int emptyTrainShipmentDuration[shipmentPoint][ shipmentPoint] = ...; //������������ ��������� �����.  -1 = ���� ����������



dvar interval Shippment[sp in shipmentPoint] optional size shippmentDuration[sp] ;

dvar interval EmptyTrainFromStartPont[w in wagons][sp in shipmentPoint] optional size shippmentStartDate[sp]-startPointStartDateWagon[w];
dvar interval EmptyTrainBetweenShipment[w in wagons][sp1 in shipmentPoint][sp2 in shipmentPoint] optional size 
shippmentStartDate[sp1] - (shippmentStartDate[sp2] + shippmentDuration[sp2]);


dvar sequence WagonSequence[w in wagons] in append 
(
	all(i in startPoint) EmptyTrainFromStartPont[w][i],
	all(sp in shipmentPoint) Shippment[sp]//,
	//all(sp1 in shipmentPoint, sp2 in shipmentPoint) EmptyTrainBetweenShipment[w][sp1][sp2]
)
types
append ( 
all(i in startPoint) 0, 
all(sp in shipmentPoint) 1//, 
//all(sp1 in shipmentPoint, sp2 in shipmentPoint) 2
);


maximize sum(sp in shipmentPoint) sizeOf (Shippment[sp]); // TODO: find new

subject to
{
	//sum(i in shipmentPoint ) presenceOf(Shippment[i]) == 1;
	

	forall(i in shipmentPoint)
	  {
	  
	  	  startOf(Shippment[i]) == shippmentStartDate[i];
	  	  endOf(Shippment[i]) == shippmentStartDate[i]+shippmentDuration[i];
	  }

	forall(w in wagons)
	  {
	  
	 // 	noOverlap(WagonSequence[w]);
	  	  
	  forall(i in shipmentPoint)
	    { 	  
		  		startOf ( EmptyTrainFromStartPont [w][i]) >= startPointStartDateWagon[w];
   		}		  	
		  	
		  forall(sp in startPoint)	
		  	{	
		  		first(WagonSequence[w], EmptyTrainFromStartPont[w][sp]);
  			}		  
	  }
	  
}