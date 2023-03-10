with concepts as (
	select CAST(ancestor_concept_id as VARCHAR) ancestor_id, CAST(descendant_concept_id as VARCHAR) descendant_id 
	from vocab_schema.concept_ancestor ca 
	where ancestor_concept_id in (?,?,?,?,?,?,?,?,?,?)
    union
    select CAST(concept_id AS VARCHAR) ancestor_id, CAST(concept_id AS VARCHAR) descendant_id
    from vocab_schema.concept c
    where concept_id in (?,?,?,?,?,?,?,?,?,?)
), counts as (
	select stratum_1 concept_id, max(count_value) agg_count_value
	from result_schema.achilles_results
	where analysis_id in (2, 4, 5, 201, 225, 301, 325, 401, 425, 501, 505, 525, 601, 625, 701, 725, 801, 825, 826, 827, 901, 1001, 1201, 1203, 1425, 1801, 1825, 1826, 1827, 2101, 2125, 2301)
	group by stratum_1
	union
	select stratum_2 as concept_id, sum(count_value) as agg_count_value
	from result_schema.achilles_results
	where analysis_id in (405, 605, 705, 805, 807, 1805, 1807, 2105)
	group by stratum_2
)
select concepts.ancestor_id concept_id, isnull(max(c1.agg_count_value),0) record_count, isnull(sum(c2.agg_count_value),0) descendant_record_count
from concepts
left join counts c1 on concepts.ancestor_id = c1.concept_id
left join counts c2 on concepts.descendant_id = c2.concept_id
group by concepts.ancestor_id
