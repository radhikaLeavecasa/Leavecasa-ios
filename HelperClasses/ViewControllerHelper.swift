//
//  ViewControllerHelper.swift
//  Josh
//
//  Created by Esfera-Macmini on 21/03/22.
//

import UIKit

enum StoryboardName : String{
    
    case Main
    case Hotels
    case Bus
    case Flight
    case Visa
}

enum ViewControllerType : String{
    
    //MARK: - USER
    case InsuranceListVC
    case FillInsuranceDetailsVC
    case InsuranceSearchVC
    case PackageFilterVC
    case SearchedPackageListsVC
    case PackageDetailVC
    case RequestCallBackVC
    case ViewController
    case CalendarPopUpVC
    case SelectGuestsPopUpVC
    case HomeVC
    case TabbarVC
    case BookingConfirmedVC
    case SearchHotelVC
    case WWCalendarTimeSelector
    case HotelListVC
    case HotelFilterVC
    case HotelDetailsVC
    case HotelRoomsVC
    case PhoneLoginVC
    case SplashVC
    case OtpVC
    case HotelMoreDetailsVC
    case HotelConfirmBookingVC
    case CouponVC
    case CouponAppliedVC
    case ProfileVC
    case NotificationVC
    case WalletVC
    case GuestLoginVC
    case WalletPaymentVC
    case FlightReviewDetailsVC
    case CommonPopupVC
    case CompleteProfilePopup
    case SlidingVC
    case MoreinfoPopUpVC
    case PlanCoveragePopVC
    case HotelCancellationPolicyVC
    case MoreInfoVC
    case InsurancePopUpVC
    //MARK: Bus
    case BusSearchVC
    case BusListVC
    case EditProfileVC
    case TripsVC
    case TripDetailsVC
    case FlightTripDetailVC
    case BusTripDetailVC
    case BusSeatVC
    case BoardingDroppingVC
    case SideMenuNavigationController
    case ConfirmBusBookingVC
    case BusTicketVC
    case BusTicketDetailsVC
    case BusFilterVC
    case BusOperatorVC
    case BusCancellationPolicyVC
    case HotelTripDetailVC
    
    //MARK: Flight
    case PackagesVC
    case SearchFlightVC
    case FlightListVC
    case FlightMultiCityVC
    case FlightFiltersVC
    case FlightReturnTripVC
    case FlighAddMealsVC
    case FlightBaggageVC
    case FareDetailsVC
    case FareBrakeupVC
    case TaxBifurcationVC
    case SelectFareVC
    case SelectSeatVC
    case FlightFareRuleVC
    case PassangerDetailsVC
    case PassangerMealandBaggageVC
    case BaggageDetailsVC
    case ExistingPassangerVC
    case FlightDomasticListVC
    case NoInternetVC
    
    case InsuranceDetailVC
    case VisaDetailsVC
    case CountryVisaDetailVC
    case UploadDocumentsVC
}

class ViewControllerHelper: NSObject {
    class func getViewController(ofType viewControllerType: ViewControllerType, StoryboardName:StoryboardName) -> UIViewController {
        var viewController: UIViewController?
        let storyboard = UIStoryboard(name: StoryboardName.rawValue, bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: viewControllerType.rawValue)
        if let vc = viewController {
            return vc
        } else {
            return UIViewController()
        }
    }
}
