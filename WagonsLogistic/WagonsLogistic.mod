 using CP;
 execute PARAMS{cp.param.TimeLimit = 60;}
 
{int} wagons = ...;
{int} points = ... ;

int startPointStartDateWagon[wagons] = ...; // время момент старта для каждого вагона
int pointOfStart[wagons] = ...;

int shippmentStartDate[points] = ...; // дата отправления груженого рейса
int shippmentDuration[points] = ...;//среднее время в пути по направлению груженого рейса
int shippmentEndDate[points] = ...;


tuple triplet {int id1; int id2; int value;};
{triplet} emptyTrainDistanceMatrix = ...;


dvar interval StartInterval[w in wagons] in 0..startPointStartDateWagon[w] size startPointStartDateWagon[w];

dvar interval Shippment[w in wagons][sp in points] optional in shippmentStartDate[sp]..shippmentEndDate[sp] size shippmentDuration[sp] ;


dvar sequence WagonSequence[w in wagons] in 
append(
all(sp in points) Shippment[w][sp],
StartInterval[w]
)
types append(  all(sp in points) sp, pointOfStart[w]);


maximize sum(w in wagons, sp in points) presenceOf (Shippment[w][sp]);

subject to
{
	forall(sp in points)
		{
			 sum (w in wagons )presenceOf(Shippment[w][sp]) <= 1;
		}
			
			
	forall(w in wagons)
		{
			noOverlap(WagonSequence[w], emptyTrainDistanceMatrix);	  
 		}	  
}