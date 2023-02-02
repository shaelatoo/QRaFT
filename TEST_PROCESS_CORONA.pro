 FUNCTION TEST_PROCESS_CORONA

  ;+
  ; NAME:
  ;     TEST_PROCESS_CORONA
  ;
  ; PURPOSE:
  ;     Runs PROCESS_CORONA.pro on a test file and compares the results to a
  ;     validation file.  Compares saved output only, not plotting.
  ;
  ; CALLING SEQUENCE:
  ;     test_result = TEST_PROCESS_CORONA()
  ;
  ; INPUTS:
  ;     none
  ;
  ; OUTPUTS:
  ;     returns 0 if test is passed
  ;
  ; RESTRICTIONS:
  ;     none
  ;
  ; MODIFICATION HISTORY:
  ;       s.i.jones, created 02 feb 2023
  ;-
  ;----------------------------------------------------------------

  ; Edit this line to direct the code to the folder containing the parameter file "fname_par" and test files
  cd, GETENV('QRaFT_PATH')

  ; Define test file, parameters
  f3 = 'cor1_512x512_w50w5_20140501133500.fits'
  features_new = PROCESS_CORONA(f3, 'COR1', /silent, thresh_k=0.5, trend_k=2.0, /save)

  ; compare saved variable names
  vfile = 'cor1_512x512_w50w5_20140501133500_val.sav'
  newfile = 'cor1_512x512_w50w5_20140501133500.fits.sav'
  sObj_new = OBJ_NEW('IDL_Savefile', vfile)
  sObj_val = OBJ_NEW('IDL_Savefile', newfile)
  comp0 = ARRAY_EQUAL(sObj_new->names(), sObj_val->names(),/not_equal)
  if comp0 ne 0 then print, 'New savefile does NOT have the same number of saved variables in it.'

  ; restore new, validation results
  RESTORE,newfile
  features_new = features
  img_orig_new = img_orig
  img_enh_new = img_enh
  img_p_enh_new = img_p_enh
  p_new = p
  header_new = header
  fname_new = fname
  RESTORE, vfile

  ; compare savefile contents from new and old versions of the code
  comp1 = COMPARE_STRUCT(features, features_new)
  comp2 = ARRAY_EQUAL(img_orig, img_orig_new, /not_equal)
  comp3 = ARRAY_EQUAL(img_enh, img_enh_new, /not_equal)
  comp4 = ARRAY_EQUAL(img_p_enh, img_p_enh_new, /not_equal)
  comp5 = COMPARE_STRUCT(p, p_new)
  comp6 = ARRAY_EQUAL(header,header_new, /not_equal)
  comp7 = ARRAY_EQUAL(fname,fname_new, /not_equal)

  ; if returns 0, new and old result are identical
  test_val = TOTAL([comp1.ndiff, comp5.ndiff, comp2, comp3, comp4, comp6, comp7])
  if test_val ne 0 then print, 'Results are NOT identical'
  RETURN, test_val

 END
