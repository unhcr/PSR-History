var errors number;

execute dbms_mview.refresh_all_mviews(:errors);
