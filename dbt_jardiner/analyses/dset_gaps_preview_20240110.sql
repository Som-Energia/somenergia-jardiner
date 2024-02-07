with
  som_uuids as (
    select distinct group_name, signal_code, signal_uuid
    from {{ ref("int_dset_responses__materialized") }}
    where ts >= '2024-01-10' and ts < '2024-01-11'
    order by signal_uuid desc),

    dset_uuids as (
      select a.gru_codi, a.gru_nom, a.sen_codi, a.sen_descripcio, a.esperats_frequencia, a.trobats_senyal, b.signal_uuid
      from analytics.se_forats_hornsby_dades_dia_10 as a
      left join som_uuids as b
      on a.sen_codi = b.signal_code
      and a.gru_nom = b.group_name),

    som_count as (
      select
        signal_uuid, count(*) as cnt
        from {{ ref("int_dset_responses__materialized") }}
        where ts >= '2024-01-10' and ts < '2024-01-11'
        and signal_value is not null
        group by signal_uuid
        order by signal_uuid desc, cnt desc),

    summary as (
      select b.*, a.cnt as som_trobats_senyal from som_count as a
        left join dset_uuids as b
        on a.signal_uuid = b.signal_uuid
        order by b.trobats_senyal desc, a.cnt desc
      ),

    final as (
      select *,
      esperats_frequencia - trobats_senyal as n_forats_dset,
      288 - som_trobats_senyal as n_forats_som
      from summary
    )

select * from final
order by gru_codi, gru_nom, sen_codi
