package com.meathill.bannerFactory.utils {
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	/**
   * ...
   * @author Meathill
   */
  public class DisplayUtils {
		public static const BLUR:BlurFilter = new BlurFilter(2, 2);
		public static const BLACK_WHITE:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 0,
                                                                            1, 0, 0, 0, 0,
                                                                            1, 0, 0, 0, 0,
                                                                            0, 0, 0, 1, 0]);
  }
}