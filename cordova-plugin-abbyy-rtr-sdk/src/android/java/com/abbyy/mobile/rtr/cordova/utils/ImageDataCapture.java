package com.abbyy.mobile.rtr.cordova.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;

import com.abbyy.mobile.rtr.Engine;
import com.abbyy.mobile.rtr.IDataCaptureCoreAPI;
import com.abbyy.mobile.rtr.Language;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.concurrent.Callable;


public class CaptureImageDataCallable implements Callable<String> {
	private String TAG = "captureDataFromImage";

	// Licensing
	private String licenseFileName;

	protected Engine engine;
	protected Bitmap image;
	protected Language recognitionLanguage;

	CaptureImageDataCallable(Context context, Bitmap image, Language recognitionLanguage )
	{
		this.image = image;
		this.recognitionLanguage = recognitionLanguage;
		this.licenseFileName = context.getResources().getString(R.string.license);
		initRecognition(context);
	}

	private void initRecognition(Context context) {

		try {
			engine = Engine.load( context, licenseFileName );
		} catch( Exception ex ) {
			Log.e( TAG, "Error loading engine", ex );
		}
	}

	// Callback for handling data extraction-time events (same as in recognition task)
	public IDataCaptureCoreAPI.Callback callback = new IDataCaptureCoreAPI.Callback() {
		@Override
		public boolean onProgress( int recognitionPercent, IDataCaptureCoreAPI.Warning warning )
		{
			String progress = String.format( "Recognition progress %d%%.", recognitionPercent );
			Log.e( TAG+" Core API\\n(RTR SDK)", "Progress: " + progress );
			// Return true for interrupting recognition, false otherwise
			return false;
		}

		@Override
		public void onTextOrientationDetected( int orientation )
		{
			// Here you can handle information about the text orientation
			// E.g. you can rotate image in UI
		}

		@Override
		public void onError( Exception e )
		{
			// Recognition process errors handling
			Log.e( TAG+" Core API\\n(RTR SDK)", "Recognition error: " + e.getMessage(), e );
		}
	};

	@Override
	public String call() throws Exception {
		// The 'Abbyy RTR SDK Core API' object to be used in this sample application
		try (IDataCaptureCoreAPI dataCaptureCoreAPI = engine.createDataCaptureCoreAPI()) {
			// Set recognition language
			dataCaptureCoreAPI.getDataCaptureSettings().setRecognitionLanguage(recognitionLanguage);
			// Set profile (for example "BusinessCards")
			dataCaptureCoreAPI.getDataCaptureSettings().setProfile("BusinessCards");
			// Do it!
			IDataCaptureCoreAPI.DataField[] dataFields = dataCaptureCoreAPI.extractDataFromImage(image, callback);

			return packJson(dataFields);
		}
	}
	private String packJson (IDataCaptureCoreAPI.DataField[] fields) {

		HashMap<String, String> resultInfo = new HashMap<>();

		ArrayList<HashMap<String, Object>> fieldList = new ArrayList<>();
		if( fields != null ) {
			for( IDataCaptureCoreAPI.DataField field : fields ) {
				HashMap<String, Object> fieldInfo = new HashMap<>();
				fieldInfo.put( "id", field.Id != null ? field.Id : "" );
				fieldInfo.put( "name", field.Name != null ? field.Name : "" );

				fieldInfo.put( "text", field.Text );
				if( field.Quadrangle != null ) {
					StringBuilder builder = new StringBuilder();
					for( int i = 0; i < field.Quadrangle.length; i++ ) {
						builder.append( field.Quadrangle[i].x );
						builder.append( ' ' );
						builder.append( field.Quadrangle[i].y );
						if( i != field.Quadrangle.length - 1 ) {
							builder.append( ' ' );
						}
					}
					fieldInfo.put( "quadrangle", builder.toString() );
				}

				ArrayList<HashMap<String, String>> lineList = new ArrayList<>();
				IDataCaptureCoreAPI.DataField[] components = field.Components;
				if( components != null ) {
					for( IDataCaptureCoreAPI.DataField line : field.Components ) {
						HashMap<String, String> lineInfo = new HashMap<>();
						lineInfo.put( "text", line.Text );
						if( line.Quadrangle != null ) {
							StringBuilder lineBuilder = new StringBuilder();
							for( int i = 0; i < line.Quadrangle.length; i++ ) {
								lineBuilder.append( line.Quadrangle[i].x );
								lineBuilder.append( ' ' );
								lineBuilder.append( line.Quadrangle[i].y );
								if( i != line.Quadrangle.length - 1 ) {
									lineBuilder.append( ' ' );
								}
							}
							lineInfo.put( "quadrangle", lineBuilder.toString() );
						}
						lineList.add( lineInfo );
					}
				} else {
					HashMap<String, String> lineInfo = new HashMap<>();
					lineInfo.put( "text", field.Text );
					if( field.Quadrangle != null ) {
						StringBuilder lineBuilder = new StringBuilder();
						for( int i = 0; i < field.Quadrangle.length; i++ ) {
							lineBuilder.append( field.Quadrangle[i].x );
							lineBuilder.append( ' ' );
							lineBuilder.append( field.Quadrangle[i].y );
							if( i != field.Quadrangle.length - 1 ) {
								lineBuilder.append( ' ' );
							}
						}
						lineInfo.put( "quadrangle", lineBuilder.toString() );
					}
					lineList.add( lineInfo );
				}
				fieldInfo.put( "components", lineList );

				fieldList.add( fieldInfo );
			}
		}

		HashMap<String, Object> json = new HashMap<>();
		json.put( "resultInfo", resultInfo );
		json.put( "dataFields", fieldList );
		return json;
	}
}
