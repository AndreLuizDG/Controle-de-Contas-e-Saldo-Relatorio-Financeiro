REPORT z_algj_41.

*--------------------------------------------------------------------*
* Declarações
*--------------------------------------------------------------------*
##NEEDED
TABLES: bkpf,
        ska1,
        glt0.

type-pools slis.

TYPES:

  BEGIN OF type_ska1,
    ktopl TYPE ska1-ktopl,
    saknr TYPE ska1-saknr,
    bilkt TYPE ska1-bilkt,
  END OF type_ska1,

  BEGIN OF type_skb1,
    bukrs TYPE skb1-bukrs,
    saknr TYPE skb1-saknr,
  END OF type_skb1,

  BEGIN OF type_skat,
    spras TYPE skat-spras,
    ktopl TYPE skat-ktopl,
    saknr TYPE skat-saknr,
    txt20 TYPE skat-txt20,
  END OF type_skat,

  BEGIN OF type_glt0,
    bukrs TYPE glt0-bukrs,
    ryear TYPE glt0-ryear,
    racct TYPE glt0-racct,
    rbusa TYPE glt0-rbusa,
    rtcur TYPE glt0-rtcur,
    tsl01 TYPE glt0-tsl01,
    tsl02 TYPE glt0-tsl02,
    tsl03 TYPE glt0-tsl03,
    tsl04 TYPE glt0-tsl04,
    tsl05 TYPE glt0-tsl05,
    tsl06 TYPE glt0-tsl06,
    tsl07 TYPE glt0-tsl07,
    tsl08 TYPE glt0-tsl08,
    tsl09 TYPE glt0-tsl09,
    tsl10 TYPE glt0-tsl10,
    tsl11 TYPE glt0-tsl11,
    tsl12 TYPE glt0-tsl12,
  END OF type_glt0,

  BEGIN OF type_saida,
    collor TYPE char4,
    bilkt  TYPE ska1-bilkt,
    racct  TYPE glt0-racct,
    txt20  TYPE skat-txt20,
    tslvt  TYPE glt0-tslvt,
  END OF type_saida.


DATA: ti_ska1       TYPE TABLE OF type_ska1,
      ti_skb1       TYPE TABLE OF type_skb1,
      ti_skat       TYPE TABLE OF type_skat,
      ti_glt0       TYPE TABLE OF type_glt0,
      ti_saida      TYPE TABLE OF type_saida,
      ti_fieldcat   TYPE TABLE OF slis_fieldcat_alv,
      ti_sort       TYPE TABLE OF slis_sortinfo_alv,
      ti_listheader TYPE TABLE OF slis_listheader.

DATA: wa_ska1       TYPE type_ska1,
      wa_skb1       TYPE type_skb1,
      wa_skat       TYPE type_skat,
      wa_glt0       TYPE type_glt0,
      wa_saida      TYPE type_saida,
      wa_fieldcat   TYPE slis_fieldcat_alv,
      wa_sort       TYPE slis_sortinfo_alv,
      wa_listheader TYPE slis_listheader.


CONSTANTS:
  c_e              TYPE char1 VALUE 'E',
  c_s              TYPE char1 VALUE 'S',
  c_x              TYPE char1 VALUE 'X',
  c_1000           TYPE char4 VALUE '1000',
  c_2018           TYPE char4 VALUE '2018',
  c_cain           TYPE char4 VALUE 'CAIN',
  c_00             TYPE char2 VALUE '00',
  c_9900           TYPE char4 VALUE '9900',
  c_eur            TYPE char3 VALUE 'EUR',
  c_c610           TYPE char4 VALUE 'C610',
  c_c310           TYPE char4 VALUE 'C310',
  c_c510           TYPE char4 VALUE 'C510',
  c_zf_top_of_page TYPE SLIS_FORMNAME VALUE 'ZF_TOP_OF_PAGE',
  c_bilkt          TYPE char5 VALUE 'BILKT',
  c_racct          TYPE char5 VALUE 'RACCT',
  c_txt20          TYPE char5 VALUE 'TXT20',
  c_tslvt          TYPE char5 VALUE 'TSLVT',
  c_ti_saida       TYPE char8 VALUE 'TI_SAIDA',
  c_ska1           TYPE char4 VALUE 'SKA1',
  c_glt0           TYPE char4 VALUE 'GLT0',
  c_skat           TYPE char4 VALUE 'SKAT',
  c_collor         TYPE char6 VALUE 'COLLOR'.

*--------------------------------------------------------------------*
* Tela
*--------------------------------------------------------------------*

  selection-screen:BEGIN OF BLOCK b1 WITH FRAME TITLE text-001. "Tela de seleção

PARAMETERS     p_bukrs TYPE bkpf-bukrs DEFAULT c_1000.
SELECT-OPTIONS s_saknr FOR  ska1-saknr.
PARAMETERS     p_ryear TYPE glt0-ryear DEFAULT c_2018.

SELECTION-SCREEN: END OF BLOCK b1.

*--------------------------------------------------------------------*
* Eventos
*--------------------------------------------------------------------*

START-OF-SELECTION.

  PERFORM: zf_seleciona_dados,
           zf_processa_dados,
           zf_monata_tabela_fieldcat,
           zf_quebra_de_campo,
           zf_mostra_alv.

*--------------------------------------------------------------------*
* Forms
*--------------------------------------------------------------------*
FORM zf_seleciona_dados.

  FREE ti_ska1.
  SELECT ktopl
         saknr
         bilkt
    FROM ska1
    INTO TABLE ti_ska1
   WHERE saknr IN s_saknr
     AND ktopl = c_cain.

  IF sy-subrc <> 0.
    FREE ti_ska1.
    MESSAGE text-e01 TYPE c_s DISPLAY LIKE c_e. "Dados não encontrados!
    LEAVE LIST-PROCESSING.
  ENDIF.


  IF ti_ska1 IS NOT INITIAL.

    FREE ti_skb1.
    SELECT bukrs
           saknr
      FROM skb1
      INTO TABLE ti_skb1
       FOR ALL ENTRIES IN ti_ska1
     WHERE saknr = ti_ska1-saknr
       AND bukrs = p_bukrs.

    IF sy-subrc <> 0.
      FREE ti_skb1.
    ENDIF.


    SELECT spras
           ktopl
           saknr
           txt20
      FROM skat
      INTO TABLE ti_skat
       FOR ALL ENTRIES IN ti_ska1
     WHERE spras = sy-langu
       AND ktopl = ti_ska1-ktopl
       AND saknr = ti_ska1-saknr.

    IF sy-subrc <> 0.
      FREE ti_skat.
    ENDIF.

  ENDIF. "IF ti_ska1 IS NOT INITIAL.


  IF ti_skb1 IS NOT INITIAL.

    FREE ti_glt0.
    SELECT bukrs
           ryear
           racct
           rbusa
           rtcur
           tsl01
           tsl02
           tsl03
           tsl04
           tsl05
           tsl06
           tsl07
           tsl08
           tsl09
           tsl10
           tsl11
           tsl12
      FROM glt0
      INTO TABLE ti_glt0
       FOR ALL ENTRIES IN ti_skb1
     WHERE rldnr = c_00
       AND bukrs = p_bukrs
       AND ryear = p_ryear
       AND racct = ti_skb1-saknr
       AND rbusa = c_9900
       AND rtcur = c_eur.

    IF sy-subrc <> 0.
      FREE ti_glt0.
    ENDIF.

  ENDIF. "IF ti_skb1 IS NOT INITIAL.

ENDFORM. "form zf_seleciona_dados.

FORM zf_processa_dados.

  SORT: ti_skb1 BY saknr
                   saknr,
        ti_ska1 BY saknr
                   saknr,
        ti_skat BY ktopl
                   saknr,
        ti_glt0 BY racct.

  LOOP AT ti_skb1 INTO wa_skb1.

    READ TABLE ti_ska1 INTO wa_ska1 WITH KEY
                                              saknr = wa_skb1-saknr BINARY SEARCH.

    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

    READ TABLE ti_skat INTO wa_skat WITH KEY
                                              ktopl = wa_ska1-ktopl
                                              saknr = wa_ska1-saknr BINARY SEARCH.

    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.


    READ TABLE ti_glt0 INTO wa_glt0 WITH KEY
                                       racct = wa_skb1-saknr BINARY SEARCH.

    IF sy-subrc = 0.

      DATA(v_somatoria) = wa_glt0-tsl01 +
                          wa_glt0-tsl02 +
                          wa_glt0-tsl03 +
                          wa_glt0-tsl04 +
                          wa_glt0-tsl05 +
                          wa_glt0-tsl06 +
                          wa_glt0-tsl07 +
                          wa_glt0-tsl08 +
                          wa_glt0-tsl09 +
                          wa_glt0-tsl10 +
                          wa_glt0-tsl11 +
                          wa_glt0-tsl12.
    ENDIF.

    wa_saida-bilkt = wa_ska1-bilkt.
    wa_saida-racct = wa_glt0-racct.
    wa_saida-txt20 = wa_skat-txt20.
    wa_saida-tslvt = v_somatoria.

    IF wa_saida-tslvt = 0.
      CONTINUE.
    ELSEIF wa_saida-tslvt <= 50000.
      wa_saida-collor = c_c610. " Vermelho
    ELSEIF wa_saida-tslvt > 50000 AND wa_saida-tslvt < 500000.
      wa_saida-collor = c_c310. " Amarelo
    ELSEIF wa_saida-tslvt > 500000.
      wa_saida-collor = c_c510. " Verde
    ENDIF.

    APPEND wa_saida TO ti_saida.
    CLEAR wa_saida.

  ENDLOOP. "loop at ti_skb1 into wa_skb1.

ENDFORM. "form zf_processa_dados.

FORM zf_monata_tabela_fieldcat.

  PERFORM zf_monta_fieldcat USING:
  c_bilkt   c_ti_saida   c_bilkt   c_ska1   '',
  c_racct   c_ti_saida   c_racct   c_glt0   '',
  c_txt20   c_ti_saida   c_txt20   c_skat   '',
  c_tslvt   c_ti_saida   c_tslvt   c_glt0   c_x.

ENDFORM.

FORM zf_monta_fieldcat USING l_fieldname     TYPE any
                             l_tabname       TYPE any
                             l_ref_fieldname TYPE any
                             l_ref_tabname   TYPE any
                             l_do_sumd       TYPE any.

  CLEAR wa_fieldcat.
  wa_fieldcat-fieldname        = l_fieldname.
  wa_fieldcat-tabname          = l_tabname.
  wa_fieldcat-ref_fieldname    = l_ref_fieldname.
  wa_fieldcat-ref_tabname      = l_ref_tabname.
  wa_fieldcat-do_sum           = l_do_sumd.
  APPEND wa_fieldcat TO ti_fieldcat.

ENDFORM.

FORM zf_mostra_alv.

  DATA: wa_layout TYPE slis_layout_alv.

  wa_layout-expand_all        = abap_true.
  wa_layout-colwidth_optimize = abap_true.
  wa_layout-zebra             = abap_true.
  wa_layout-info_fieldname    = c_collor.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = c_zf_top_of_page
      is_layout              = wa_layout
      it_fieldcat            = ti_fieldcat
      it_sort                = ti_sort
    TABLES
      t_outtab               = ti_saida
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
    MESSAGE text-e02 TYPE c_s DISPLAY LIKE c_e. "Erro ao exibir o relatório!
  ENDIF.


ENDFORM.

FORM zf_quebra_de_campo.

  FREE ti_sort.

  CLEAR wa_sort.
  wa_sort-spos      = 1.
  wa_sort-fieldname = c_bilkt.
  wa_sort-tabname   = c_ti_saida.
  wa_sort-up        = abap_true.
  wa_sort-subtot    = abap_true.
  APPEND wa_sort TO ti_sort.

ENDFORM. "form zf_quebra_de_campo

##CALLED
FORM zf_top_of_page.

  DATA: data      TYPE char10,
        hora      TYPE char5,
        timestamp TYPE char20.


  CONCATENATE sy-datum+6(2)
              sy-datum+4(2)
              sy-datum+0(4)
             INTO  data SEPARATED BY '/'.

  CONCATENATE sy-uzeit+0(2)
              sy-uzeit+2(2)
             INTO hora SEPARATED BY ':'.

  CONCATENATE data hora INTO timestamp SEPARATED BY space.

  FREE: ti_listheader[], wa_listheader.

  CLEAR wa_listheader.
  wa_listheader-typ  = c_s.
  wa_listheader-info = text-001 && p_bukrs. "Epresa:
  APPEND wa_listheader TO ti_listheader.
  FREE wa_listheader.

  CLEAR wa_listheader.
  wa_listheader-typ  = c_s.
  wa_listheader-info = text-002 && wa_ska1-ktopl. "Plano de contas:
  APPEND wa_listheader TO ti_listheader.
  FREE wa_listheader.

  CLEAR wa_listheader.
  wa_listheader-typ  = c_s.
  wa_listheader-info = text-003 && p_ryear. "Exercício:
  APPEND wa_listheader TO ti_listheader.
  FREE wa_listheader.

  CLEAR wa_listheader.
  wa_listheader-typ  = c_s.
  wa_listheader-info = text-004 && timestamp. "Data e Hora da Execução:
  APPEND wa_listheader TO ti_listheader.
  FREE wa_listheader.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = ti_listheader.


ENDFORM.
