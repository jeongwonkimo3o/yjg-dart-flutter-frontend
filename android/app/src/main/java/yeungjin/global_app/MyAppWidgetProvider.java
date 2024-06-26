package yeungjin.global_app;

import android.appwidget.AppWidgetProvider;
import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.app.PendingIntent;
import android.widget.RemoteViews;
import com.example.yjg.MainActivity;


public class MyAppWidgetProvider extends AppWidgetProvider {
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        final int N = appWidgetIds.length;
        for (int i = 0; i < N; i++) {
            int appWidgetId = appWidgetIds[i];
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.meal_widget_layout);
            Intent intent = new Intent(context, MainActivity.class);
            intent.setAction("ACTION_MEAL_QR_" + appWidgetId);  // 고유 액션 설정
            intent.putExtra("openPage", "/meal_qr");
            PendingIntent pendingIntent = PendingIntent.getActivity(context, appWidgetId, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
            views.setOnClickPendingIntent(R.id.appwidget_image, pendingIntent);
            appWidgetManager.updateAppWidget(appWidgetId, views);
        }
    }
}