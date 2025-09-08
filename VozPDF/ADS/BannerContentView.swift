//
//  BannerContentView.swift
//  VozPDF
//
//  Created by Vagner Oliveira on 08/09/25.
//

import GoogleMobileAds
import SwiftUI

struct BannerContentView: View {
  let navigationTitle: String

  // [START add_banner_to_view]
  var body: some View {
    Spacer()
    // Request an anchored adaptive banner with a width of 375.
    let adSize = currentOrientationAnchoredAdaptiveBanner(width: 375)
    BannerViewContainer(adSize)
      .frame(width: adSize.size.width, height: adSize.size.height)
      // [START_EXCLUDE silent]
      .navigationTitle(navigationTitle)
    // [END_EXCLUDE]
  }
  // [END add_banner_to_view]
}

// [START create_banner_view]
private struct BannerViewContainer: UIViewRepresentable {
  typealias UIViewType = BannerView
  let adSize: AdSize

  init(_ adSize: AdSize) {
    self.adSize = adSize
  }

  func makeUIView(context: Context) -> BannerView {
    let banner = BannerView(adSize: adSize)
    // [START load_ad]
    banner.adUnitID = "ca-app-pub-6352845593192241/9005040594"
    banner.load(Request())
    // [END load_ad]
    // [START set_delegate]
    banner.delegate = context.coordinator
    // [END set_delegate]
    return banner
  }

  func updateUIView(_ uiView: BannerView, context: Context) {}

  func makeCoordinator() -> BannerCoordinator {
    return BannerCoordinator(self)
  }
  // [END create_banner_view]

  class BannerCoordinator: NSObject, BannerViewDelegate {

    let parent: BannerViewContainer

    init(_ parent: BannerViewContainer) {
      self.parent = parent
    }

    // MARK: - GADBannerViewDelegate methods

    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
      print("DID RECEIVE AD.")
    }

    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
      print("FAILED TO RECEIVE AD: \(error.localizedDescription)")
    }
  }
}

