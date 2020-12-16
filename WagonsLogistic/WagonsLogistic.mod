 using CP;
  execute PARAMS{cp.param.TimeLimit = 60;}
 
{int} wagons = ...;
{int} shipmentPoint = ... ;
{int} startPoint = ...;

int startPointStartDateWagon[wagons] = ...; // ����� ������ ������ ��� ������� ������
int pointOfStart[wagons] = ...;

int shippmentStartDate[shipmentPoint] = ...; // ���� ����������� ��������� �����
int shippmentDuration[shipmentPoint] = ...;//������� ����� � ���� �� ����������� ��������� �����
int shippmentEndDate[shipmentPoint] = ...;

int emptyTrainStartDuration [startPoint] [ shipmentPoint] = ...;
int emptyTrainShipmentDuration[shipmentPoint][ shipmentPoint] = ...; //������������ ��������� �����.  -1 = ���� ����������

tuple triplet {int id1; int id2; int value;};
{triplet} emptyTrainDistanceMatrix = ...;


dvar interval Shippment[w in wagons][sp in shipmentPoint] optional in shippmentStartDate[sp]..shippmentEndDate[sp] size shippmentDuration[sp] ;


dvar sequence WagonSequence[w in wagons] in all(sp in shipmentPoint) Shippment[w][sp]
types   all(sp in shipmentPoint) sp;


maximize sum(w in wagons, sp in shipmentPoint) presenceOf (Shippment[w][sp]);

subject to
{
	forall(sp in shipmentPoint)
		{
			 sum (w in wagons )presenceOf(Shippment[w][sp]) == 1;
		}
			
			
	forall(w in wagons)
		{
			noOverlap(WagonSequence[w], emptyTrainDistanceMatrix);	  
 		}	  
}