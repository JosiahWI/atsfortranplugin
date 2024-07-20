!> An ATS plugin written in Fortran.

module yay
  use, intrinsic :: iso_c_binding
  implicit none    

  private
  public :: init

  type, bind(C) :: reg_info_type
    character(kind = c_char) :: plugin_name
    character(kind = c_char) :: vendor
    character(kind = c_char) :: support_email
  end type

  interface

    integer(kind = c_int) function ts_plugin_register(info) bind(C, name='_Z16TSPluginRegisterPK24TSPluginRegistrationInfo')
      use, intrinsic :: iso_c_binding

      type(c_ptr), intent(in) :: info
    end function ts_plugin_register

  end interface

  character(len = 15), target :: plugin_name   = 'Fortran Plugin' // achar(0)
  character(len = 27), target :: vendor        = 'Apache Software Foundation' // achar(0)
  character(len = 29), target :: support_email = 'dev@trafficserver.apache.org' // achar(0)

contains


  !> Initialize the plugin.
  function init() result(success) bind(C, name='TSPluginInit')
    integer(kind = c_int) :: success
   
    success = register()
  end function init

  function register() result(success)
    integer(kind = c_int)                    :: success
    type(reg_info_type), allocatable, target :: info
    type(reg_info_type), pointer             :: info_ptr
    character(len = :), pointer              :: plugin_name_ptr
    character(len = :), pointer              :: vendor_ptr
    character(len = :), pointer              :: support_email_ptr

    plugin_name_ptr   => plugin_name
    vendor_ptr        => vendor
    support_email_ptr => support_email

    allocate(info);
    info%plugin_name   = plugin_name_ptr
    info%vendor        = vendor_ptr
    info%support_email = support_email_ptr

    info_ptr => info

    success = ts_plugin_register(c_loc(info_ptr))
  end function register

end module yay
